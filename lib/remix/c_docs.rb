class Module
  # Includes a module at a particular index in the ancestor
  # chain.
  #
  # @param [Fixnum] index The index where the module will be included
  # (must be > 1.)
  # @param [Module] mod The module to include
  # @return [Module] The receiver
  # @example
  #   module M end
  #   module N end
  #   module O end
  #   module P
  #     include M, N
  #   end
  #   P.include_at 2, O
  #   P.ancestors #=> [P, M, O, N]
  def include_at(index, mod) end

  # Includes a module below a specific module in the ancestor chain.
  # @param [Module] mod1 Module with position
  # @param [Module] mod2 Module that will be included
  # @return [Module] The receiver
  # @example
  #   M.ancestors #=> [M, A, B]
  #   M.include_below B, J
  #   M.ancestors #=> [M, A, J, B]
  def include_below(mod1, mod2) end

  # Includes a module above a specific module in the ancestor chain.
  # @param [Module] mod1 Module with position
  # @param [Module] mod2 Module that will be included
  # @return [Module] The receiver
  # @example
  #   M.ancestors #=> [M, A, B]
  #   M.include_above B, J
  #   M.ancestors #=> [M, A, B, J]
  def include_above(mod1, mod) end
  
  # Includes a module at top of ancestor chain
  # @param [Module] mod Module that will be included
  # @return [Module] The receiver
  # @example
  #   M.ancestors #=> [M, A, B]
  #   M.include_at_top J
  #   M.ancestors #=> [M, A, B, J]
  def include_at_top(mod) end
    
  # Moves a module up one position in the ancestor chain.
  # Module must already be in ancestor chain.
  # @param [Module] Module to move up
  # @return [Module] The receiver
  # @example
  #   M.ancestors #=> [M, A, B]
  #   M.module_move_up A
  #   M.ancestors #=> [M, B, A]
  def module_move_up(mod) end

  # Moves a module down one position in the ancestor chain.
  # Module must already be in ancestor chain.
  # @param [Module] Module to move down
  # @return [Module] The receiver
  # @example
  #   M.ancestors #=> [M, A, B]
  #   M.module_move_down B
  #   M.ancestors #=> [M, B, A]
  def module_move_down(mod) end

  # Unincludes a module from an ancestor chain with optional recursion
  # for nested modules.
  # @param [Module] mod The module to uninclude
  # @param [Boolean] recurse Set to true to remove nested modules
  # @return [Module] The receiver
  # @example
  #   module C
  #     include A, B
  #   end
  #   M.ancestors #=> [M, C, A, B]
  #   M.uninclude C
  #   M.ancestors #=> [M, A, B]
  # @example With recursion
  #   module C
  #     include A, B
  #   end
  #   M.ancestors #=> [M, C, A, B]
  #   M.uninclude C, true
  #   M.ancestors #=> [M]
  def uninclude(mod, recurse = false) end

  # Swaps the position of two modules that already exist in an
  # ancestor chain.
  # @param [Module] mod1 Module to swap
  # @param [Module] mod2 Module to swap
  # @return [Module] The receiver
  # @example
  #   M.ancestors #=> [M, A, B, C, D]
  #   M.swap_modules A, D
  #   M.ancestors #=> [M, D, B, C, A]
  def swap_modules(mod1, mod2) end

  # Replaces a module with another module that is not already in the
  # ancestor chain.
  # @param [Module] mod1 The module to be replaced
  # @param [Module] mod2 The module that will replace
  # @return [Module] The receiver
  # @example
  #   J = Module.new
  #   M.ancestors #=> [M, A, B]
  #   M.replace_module B, J
  #   M.ancestors #=> [M, A, J]
  def replace_module(mod1, mod2) end
end
