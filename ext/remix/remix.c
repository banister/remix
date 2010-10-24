/* object2module.c */
/* (C) John Mair 2009
 * This program is distributed under the terms of the MIT License
 *                                                                */

#include <ruby.h>
#include "compat.h"

/* a modified version of include_class_new from class.c */
static VALUE
j_class_new(VALUE module, VALUE sup)
{

  VALUE klass = create_class(T_ICLASS, rb_cClass);

  if (TYPE(module) == T_ICLASS) {
    klass = module;
  }

  if (!RCLASS_IV_TBL(module)) {
    RCLASS_IV_TBL(module) = (struct st_table *)st_init_numtable();
  }

  /* assign iv_tbl, m_tbl and super */
  RCLASS_IV_TBL(klass) = RCLASS_IV_TBL(module);

  rb_iv_set(klass, "__module__", module);
  
  RCLASS_SUPER(klass) = sup;
  if(TYPE(module) != T_OBJECT) {
    RCLASS_M_TBL(klass) = RCLASS_M_TBL(module);
  }
  else {
    RCLASS_M_TBL(klass) = RCLASS_M_TBL(CLASS_OF(module));
  }

  /* */

  if (TYPE(module) == T_ICLASS) {
    KLASS_OF(klass) = KLASS_OF(module);
  }
  else {
    KLASS_OF(klass) = module;
  }

  if(TYPE(module) != T_OBJECT) {
    OBJ_INFECT(klass, module);
    OBJ_INFECT(klass, sup);
  }

  return (VALUE)klass;
}

static VALUE
set_supers(VALUE c)
{
  if (RCLASS_SUPER(c) == rb_cObject || RCLASS_SUPER(c) == Qnil) {
    return RCLASS_SUPER(c);
  }
  else {
    return j_class_new(RCLASS_SUPER(c), set_supers(RCLASS_SUPER(c)));
  }
}

VALUE
rb_prepare_for_remix(VALUE klass)
{
  if (!RTEST(rb_obj_is_kind_of(klass, rb_cModule)))
    rb_raise(rb_eTypeError, "Must be a Module or Class type.");

  RCLASS_SUPER(klass) = set_supers(klass);

  rb_clear_cache();
  return klass;
}

VALUE
rb_include_at(VALUE self, VALUE mod, VALUE rb_index)
{
  int index = FIX2INT(rb_index);
  VALUE m = self;

  rb_prepare_for_remix(self);
  
  int i = 0;
  while(i++ < index && RCLASS_SUPER(m) != Qnil && RCLASS_SUPER(m) != rb_cObject)
    m = RCLASS_SUPER(m);

  rb_include_module(m, mod);
  return self;
}

void
Init_remix()
{
  rb_define_method(rb_cObject, "ready_remix", rb_prepare_for_remix, 0);
  rb_define_method(rb_cModule, "include_at", rb_include_at, 2);
}

