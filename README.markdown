Remix
--------------

(c) John Mair (banisterfiend) 
MIT license

Makes inheritance chains read/write

** This is BETA software and has not yet been thoroughly tested, use
   at own risk **

example: 

    module M
    end

    class A
    end

    class B < A
      include_at(M, 1)
    end

    B.ancestors #=> [B, A, M, ...]
