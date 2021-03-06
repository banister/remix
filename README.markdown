Remix
=======

(C) John Mair (banisterfiend) 2010

_Ruby modules remixed and remastered_

Remix is a library to give you total control over class and module ancestor
chains. 

Using Remix you can add a module at any point in the chain,
remove modules, replace modules, move modules around and otherwise
'remix' your modules.

* Install the [gem](https://rubygems.org/gems/remix): `gem install remix`
* Read the [documentation](http://rdoc.info/github/banister/remix/master/file/README.markdown)
* See the [source code](http://github.com/banister/remix)

example: temp_include():
------------------------

Using `temp_include` we can temporaliy mix in a module for the
duration of a block:

    module M def hello() :hello end end
    
    String.temp_include(M) do
      puts "test".hello #=> "hello"
    end
    
    "test".hello #=> NoMethodError
    
example: unextend()
--------------------

Like the Mixico library Remix allows you to unextend
(or uninclude) modules from inheritance chains; but also extends this
functionality by (optionally) removing nested modules too:

    C.ancestors #=> [C, A, B]
    
    o = Object.new
    o.extend C
    o.singleton_class.ancestors #=> [C, A, B, Object, ...]
    
    # remove entire nested module C by passing true as second parameter
    o.unextend C, true
    
    o.singleton_class.ancestors #=> [Object, ...]
    
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

* [Include Complete](http://github.com/banister/include_complete) - Brings in
  module singleton classes during an include. No more ugly ClassMethods and included() hook hacks.
* [Object2module](http://github.com/banister/object2module) - Convert Classes and Objects to Modules so they can be extended/included
* [Prepend](http://github.com/banister/prepend) - Prepends modules in front of a class; so method lookup starts with the module
* [GenEval](http://github.com/banister/gen_eval) - A strange new breed of instance_eval

Full list of functions
----------------------

**include-based functions:**

* temp_include(mod)
* include_at(index, mod)
* include_at_top(mod)
* include_before(before_mod, mod)
* include_after(after_mod, mod)
* swap_modules(mod1, mod2)
* uninclude(mod, recurse=fale)
* module_move_up(mod)
* module_move_down(mod)
* replace_module(mod1, mod2)

**extend-based functions:**

* temp_extend(mod)
* extend_at(index, mod)
* extend_at_top(mod)
* extend_before(before_mod, mod)
* extend_after(after_mod, mod)
* swap_extended_modules(mod1, mod2)
* unextend(mod, recurse=false)
* extended_module_move_up(mod)
* extended_module_move_down(mod)
* replace_extended_module(mod1, mod2)

Limitations
------------

Remix does not currently reorder the singleton classes of superclasses
to reflect the new position of the class. This functionality is coming
soon.

Special Thanks
---------------

[Asher](http://github.com/asher-)

Contact
-------

Problems or questions contact me at [github](http://github.com/banister)

Dedication
----------

For Rue (1977-)


