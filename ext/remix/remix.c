/* remix.c */
/* (C) John Mair 2010
 * This program is distributed under the terms of the MIT License
 *                                                                */

#include <ruby.h>
#include "compat.h"

VALUE rb_swap_modules(VALUE self, VALUE mod1, VALUE mod2);

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

  if (TYPE(module) == T_ICLASS) {
    if (!RTEST(rb_iv_get(module, "__module__")))
      rb_iv_set(klass, "__module__", KLASS_OF(module));
  }
  else if (TYPE(module) == T_MODULE || TYPE(module) == T_CLASS)
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
    KLASS_OF(klass) = rb_iv_get(klass, "__module__");
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
  if (RCLASS_SUPER(c) == rb_cObject || RCLASS_SUPER(c) == 0) {
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

inline static VALUE
get_source_module(VALUE mod)
{
  switch (TYPE(mod)) {
  case T_FALSE:
    return Qfalse;
    break;
  case T_ICLASS:
    if (RTEST(rb_iv_get(mod, "__module__")))
      return rb_iv_get(mod, "__module__");
    else
      return KLASS_OF(mod);
    break;
  case T_CLASS:
  case T_MODULE:
    return mod;
    break;
  default:
    rb_raise(rb_eRuntimeError, "get_source_module: mod is not a class or iclass!");
  }
  
  /* never reached */
  return Qnil;
}

static VALUE
retrieve_before_mod(VALUE m, VALUE before)
{
  VALUE k = get_source_module(RCLASS_SUPER(m));
  while(k != before && m != 0 && m != rb_cObject) {
    m = RCLASS_SUPER(m);
    k = get_source_module(RCLASS_SUPER(m));
  }
  if (k != before)
    rb_raise(rb_eRuntimeError, "'before' module not found");

  return m;
}

static VALUE
retrieve_mod(VALUE m, VALUE after)
{
  VALUE k = get_source_module(m);
  while(k != after && m != 0 && m != rb_cObject) {
    m = RCLASS_SUPER(m);
    k = get_source_module(m);
  }

  if (k != after)
    rb_raise(rb_eRuntimeError, "'after' module not found");

  return m;
}

VALUE
rb_module_move_up(VALUE self, VALUE mod)
{
  rb_prepare_for_remix(self);

  VALUE included_mod = retrieve_mod(self, mod);
  if (RCLASS_SUPER(included_mod) == rb_cObject || RCLASS_SUPER(included_mod) == 0)
    return self;
  
  rb_swap_modules(self, mod, get_source_module(RCLASS_SUPER(included_mod)));

  return self;
}

VALUE
rb_module_move_down(VALUE self, VALUE mod)
{
  rb_prepare_for_remix(self);

  VALUE before_included_mod = retrieve_before_mod(self, mod);
  if (before_included_mod == self)
    return self;
   
  rb_swap_modules(self, mod, get_source_module(before_included_mod));

  return self;
}



VALUE
rb_include_at_top(VALUE self, VALUE mod)
{
  rb_prepare_for_remix(self);

  if (TYPE(self) == T_MODULE)
    rb_include_module(retrieve_before_mod(self, Qfalse), mod);
  else
    rb_include_module(retrieve_before_mod(self, rb_cObject), mod);

  return self;
}

VALUE
rb_include_after(VALUE self, VALUE after, VALUE mod)
{
  rb_prepare_for_remix(self);
  rb_include_module(retrieve_mod(self, after), mod);
  return self;
}

VALUE
rb_include_before(VALUE self, VALUE before, VALUE mod)
{
  rb_prepare_for_remix(self);
  rb_include_module(retrieve_before_mod(self, before), mod);
  return self;
}

VALUE
rb_include_at(VALUE self, VALUE mod, VALUE rb_index)
{
  rb_prepare_for_remix(self);

  int index = FIX2INT(rb_index);
  VALUE m = self;

  int i = 0;
  while(i++ < index && RCLASS_SUPER(m) != 0 && RCLASS_SUPER(m) != rb_cObject)
    m = RCLASS_SUPER(m);

  rb_include_module(m, mod);
  return self;
}

#define SWAP(X, Y)  {(X) ^= (Y); (Y) ^= (X); (X) ^= (Y);}

/* VALUE */
/* rb_swap_modules(VALUE self, VALUE mod1, VALUE mod2) */
/* { */
/*   rb_prepare_for_remix(self); */

/*   if (mod1 == rb_cObject || mod2 == rb_cObject) rb_raise(rb_eRuntimeError, "can't swap Object"); */

/*   SWAP(RCLASS_SUPER(retrieve_before_mod(self, mod1)), RCLASS_SUPER(retrieve_before_mod(self, mod2))); */
/*   SWAP(RCLASS_SUPER(retrieve_mod(self, mod1)), RCLASS_SUPER(retrieve_mod(self, mod2))); */

/*   rb_clear_cache(); */
/*   return  self; */
/* } */

VALUE
rb_swap_modules(VALUE self, VALUE mod1, VALUE mod2)
{
  rb_prepare_for_remix(self);

  VALUE before_mod1, before_mod2;
  VALUE included_mod1, included_mod2;

  if (mod1 == rb_cObject || mod2 == rb_cObject) rb_raise(rb_eRuntimeError, "can't swap Object");

  included_mod1 = retrieve_mod(self, mod1);
  included_mod2 = retrieve_mod(self, mod2);
  before_mod1 = retrieve_before_mod(self, mod1);
  before_mod2 = retrieve_before_mod(self, mod2);

  SWAP(RCLASS_SUPER(before_mod1), RCLASS_SUPER(before_mod2));
  SWAP(RCLASS_SUPER(included_mod1), RCLASS_SUPER(included_mod2));

  rb_clear_cache();

  return  self;
}


VALUE
rb_remove_module(VALUE self, VALUE mod1)
{
  rb_prepare_for_remix(self);

  VALUE before = retrieve_before_mod(self, mod1);
  VALUE included_mod = retrieve_mod(self, mod1);
  
  if (mod1 == rb_cObject) rb_raise(rb_eRuntimeError, "can't delete Object");
  RCLASS_SUPER(before) = RCLASS_SUPER(included_mod);
  rb_clear_cache();

  return self;
}

VALUE
rb_replace_module(VALUE self, VALUE mod1, VALUE mod2)
{
  rb_prepare_for_remix(self);

  if (rb_mod_include_p(self, mod2))
    return rb_swap_modules(self, mod1, mod2);
  
  VALUE before = retrieve_before_mod(self, mod1);
  rb_remove_module(self, mod1);
  rb_include_module(before, mod2);
  return self;
}

void
Init_remix()
{
  rb_define_method(rb_cObject, "ready_remix", rb_prepare_for_remix, 0);
  rb_define_method(rb_cModule, "module_move_up", rb_module_move_up, 1);
  rb_define_method(rb_cModule, "module_move_down", rb_module_move_down, 1);

  rb_define_method(rb_cModule, "include_at", rb_include_at, 2);
  rb_define_method(rb_cModule, "include_before", rb_include_before, 2);
  rb_define_method(rb_cModule, "include_after", rb_include_after, 2);
  rb_define_method(rb_cModule, "include_at_top", rb_include_at_top, 1);

  rb_define_method(rb_cModule, "swap_modules", rb_swap_modules, 2);
  rb_define_method(rb_cModule, "remove_module", rb_remove_module, 1);
  rb_define_method(rb_cModule, "replace_module", rb_replace_module, 2);
}

