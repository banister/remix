Remix
=======

"Ruby modules remixed and remastered"

Remix is a Ruby library that gives you complete control over class and module ancestor
chains. Using Remix you can add a module at any point in the chain,
remove modules, replace modules with other ones, and move modules around
within the chain.

example:
    # ... modules A, B, C, and J defined here
    
    module M
      include A, B, C
    end
    
    M.ancestors #=> [M, A, B, C]
    
    # Now let's insert a module between A and B
    M.include_above A, J
    
    # Modified ancestor chain
    M.ancestors #=> [M, A, J, B, C]
    
install the gem: **for testing purposes only**
`gem install remix`

Currently supports:

* include_at(index)
* include_at_top(Mod)
* include_before(BeforeMod, Mod)
* include_after(AfterMod, Mod)
* swap_modules(Mod1, Mod2)
* remove_module(Mod)
* module_move_up(Mod)
* module_move_down(Mod)
* replace_module(Mod1, Mod2)
* ...more to come!

