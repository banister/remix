Remix
=======

(C) John Mair (banisterfiend) 2010

_Ruby modules remixed and remastered_

Remix is a library to give you total control over class and module ancestor
chains. 

Using Remix you can add a module at any point in the chain,
remove modules, replace modules, move modules around and otherwise
'remix' your modules.

* Install the gem [gem](https://rubygems.org/gems/remix) `gem install remix`
* Read the [documentation](http://rdoc.info/github/banister/remix/master/file/README.markdown)
* See the [source code](http://github.com/banister/remix)

example - include_at_top():
--------------------------

Using `include_at_top` we can include a module at the top of a chain
rather than at the bottom (the default).

    # ... modules A, B, C, and J defined above...
    
    module M
      include A, B, C
    end
    
    M.ancestors #=> [M, A, B, C]
    
    # Now let's insert a module between A and B
    M.include_at_top J
    
    # Modified ancestor chain
    M.ancestors #=> [M, A, B, C, J]
    
example - unextend()
--------------------

Like the Mixico library Remix allows you to unextend
(or uninclude) modules from inheritance chains; but also extends this
functionality by (optionally) removing nested modules too:


    # ...modules A, B defined above...
    
    module C
      include A, B
    end
    
    D = Object.new
    D.extend C
    D.singleton_class.ancestors #=> [C, A, B, Object, ...]
    
    # remove entire nested module C by passing true as second parameter
    D.unextend C, true
    
    D.singleton_class.ancestors #=> [Object, ...]
    
Special features
------------------

Remix is intelligent enough to manipulate classes as well as
modules:

    class D < C
      include M
    end
    
    D.ancestors #=> [D, M, C]
    
    D.swap_modules C, M
    
    D.ancestors #=> [D, C, M]
    
It does this by first converting all superclasses to Included Modules
before remixing takes place.

How it works
--------------

Remix is a C-based extension that directly manipulates the superclass
pointers of Included Modules.

Companion Libraries
--------------------

Remix is one of a series of experimental libraries that mess with
the internals of Ruby to bring new and interesting functionality to
the language, see also:

* [Real Include](http://github.com/banister/real_include) - Brings in
  module singleton classes during an include. No more ugly ClassMethods and included() hook hacks.
* [Object2module](http://github.com/banister/object2module) - Convert Classes and Objects to Modules so they can be extended/included
* [Prepend](http://github.com/banister/prepend) - Prepends modules in front of a class; so method lookup starts with the module
* [GenEval](http://github.com/banister/gen_eval) - A strange new breed of instance_eval

Full list of functions
----------------------

**include-based functions:**

* include_at(index)
* include_at_top(mod)
* include_before(before_mod, mod)
* include_after(after_mod, mod)
* swap_modules(mod1, mod2)
* uninclude(mod, recurse=fale)
* module_move_up(mod)
* module_move_down(mod)
* replace_module(mod1, mod2)
* ...more to come!

**extend-based functions:**

* extend_at(index)
* extend_at_top(mod)
* extend_before(before_mod, mod)
* extend_after(after_mod, mod)
* swap_extended_modules(mod1, mod2)
* replace_module(mod1, mod2)
* unextend(mod, recurse=false)
* extended_module_move_up(mod)
* extended_module_move_down(mod)


Contact
-------

Problems or questions contact me at [github](http://github.com/banister)
