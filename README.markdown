Remix
=======

_Ruby modules remixed and remastered_

Remix is a library to give you total control over class and module ancestor
chains.

Using Remix you can add a module at any point in the chain,
remove modules, replace modules with other ones, and move modules around
within the chain.

* Install the gem [gem](https://rubygems.org/gems/remix) `gem install remix`
* Read the [documentation](http://rdoc.info/github/banister/remix/master/file/README.markdown)
* See the [source code](http://github.com/banister/remix)

example - include_above():
--------------------------

    # ... modules A, B, C, and J defined above...
    
    module M
      include A, B, C
    end
    
    M.ancestors #=> [M, A, B, C]
    
    # Now let's insert a module between A and B
    M.include_above A, J
    
    # Modified ancestor chain
    M.ancestors #=> [M, A, J, B, C]
    
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
    
Full list of functions
----------------------

include-based functions:

* include_at(index)
* include_at_top(mod)
* include_before(before_mod, mod)
* include_after(after_mod, mod)
* swap_modules(mod1, mod2)
* uninclude(mod)
* module_move_up(mod)
* module_move_down(mod)
* replace_module(mod1, mod2)
* ...more to come!

extend-based functions:

* extend_at(index)
* extend_at_top(mod)
* extend_before(before_mod, mod)
* extend_after(after_mod, mod)
* swap_extended_modules(mod1, mod2)
* replace_module(mod1, mod2)
* unextend(mod)
* extended_module_move_up(mod)
* extended_module_move_down(mod)
