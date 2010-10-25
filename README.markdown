Remix
--------------

(c) John Mair (banisterfiend) 
MIT license

Makes inheritance chains read/write

** This is BETA software and has not yet been thoroughly tested, use
   at own risk **

Currently supports:

* include_at(index)
* include_before(BeforeMod, Mod)
* include_after(AfterMod, Mod)
* swap_modules(Mod1, Mod2)
* remove_module(Mod)
* ...more to come!

example: 

    module M end

    class A; end

    class B < A
      include_after(A, M)
    end

    B.ancestors #=> [B, A, M, ...]
    B.swap_modules A, M
    B.ancestors #=> [B, M, A, ...]
    module J end
    B.include_before A, J
    B.ancestors #=> [B, M, J, A, ...]
    B.remove_module M
    B.ancestors #=> [B, J, A, ...]
    
    