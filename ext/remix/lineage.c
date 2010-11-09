#include <ruby.h>
#include "compat.h"

inline static assoc_class(VALUE self) { return rb_iv_get(self, "__assoc_class__"); }

static VALUE
initialize_lineage(self, obj)
{
  rb_iv_set(self, "__assoc_class__", obj);

  return Qnil;
}

#define CREATE_LINEAGE_METHOD(prefix, meth, num_args)    \
  static VALUE \
  prefix##meth(VALUE self, ...) \
  { \
  va_list ap; \
  VALUE args[num_args]; \
  va_start(ap, self);  \
  for (int i = 0; i < num_args; i++) \
    }
  



static VALUE
swap(self, mod1, mod2)
{
  return rb_swap_modules(assoc_class(self), mod1, mod2);
}

static VALUE
move_up(self, mod1)
{
  return rb_module_move_up(assoc_class(self), mod1, mod2);
}

static VALUE
move_down(self, mod1)
{
  return rb_module_move_up(assoc_class(self), mod1, mod2);
}

static VALUE
move_down(self, mod1)
{
  return rb_module_move_up(assoc_class(self), mod1, mod2);
}

static VALUE
uninclude(VALUE self, VALUE mod1)
{
  return rb_remove



void
Init_lineage()
{
  VALUE cLineage = rb_define_class(rb_cObject, "Lineage");
  rb_define_method(cLineage, "initialize", initialize_lineage);
  
  
