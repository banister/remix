# remix.rb
# (C) John Mair (banisterfiend); MIT license

direc = File.dirname(__FILE__)

require 'rbconfig'
require "#{direc}/remix/version"
require "#{direc}/remix/c_docs"

dlext = Config::CONFIG['DLEXT']

begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/1.9/remix.#{dlext}"
    else
        require "#{direc}/1.8/remix.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/remix.#{dlext}"
end

module Kernel
  # define a `singleton_class` method for the 1.8 kids
  # @return [Class] The singleton class of the receiver
  def singleton_class
    class << self; self; end
  end if !respond_to?(:singleton_class)
end

module Remix::ObjectExtensions

  # Temporarily extends a module for the duration of a block.
  # Module will be unextended at end of block.
  # @param [Module] mod Module to be temporarily extended
  def temp_extend(mod, &block)
    begin
      extend(mod)
      yield
    ensure
      unextend(mod, true)
    end
  end

  # Temporarily extends a module for the duration of a block in a
  # thread-safe manner.
  # Module will be unextended at end of block.
  # @param [Module] mod Module to be temporarily extended
  def temp_extend_safe(mod, &block)
    safe_code = proc do
      begin
        extend(mod)
        yield
      ensure
        unextend(mod, true)
      end
    end
    
    if !@__exclusive__
      @__exclusive__ = true
      Thread.exclusive(&safe_code)
      remove_instance_variable(:@__exclusive__)
    else
      safe_code.call
    end
  end

  # Like `include_at()` but for the singleton class
  # @see Remix::ModuleExtensions#include_at
  def extend_at(index, mod)
    singleton_class.include_at(index, mod)
  end

  # Like `include_below()` but for the singleton class
  # @see Remix::ModuleExtensions#include_below
  def extend_below(mod1, mod2)
    singleton_class.include_below(mod1, mod2)
  end
  alias_method :extend_before, :extend_below

  # Like `include_above()` but for the singleton class
  # @see Remix::ModuleExtensions#include_above
  def extend_above(mod1, mod2)
    singleton_class.include_above(mod1, mod2)
  end
  alias_method :extend_after, :extend_above

  # Like `uninclude()` but for the singleton class
  # @see Remix::ModuleExtensions#uninclude
  def unextend(mod, recurse = false)
    singleton_class.uninclude(mod, recurse)
  end
  alias_method :remove_extended_module, :unextend

  # Like `include_at_top()` but for the singleton class
  # @see Remix::ModuleExtensions#include_at_top
  def extend_at_top(mod)
    singleton_class.include_at_top(mod)
  end

  # Like `swap_modules()` but for the singleton class
  # @see Remix::ModuleExtensions#swap_modules
  def swap_extended_modules(mod1, mod2)
    singleton_class.swap_modules(mod1, mod2)
  end

  # Like `module_move_up()` but for the singleton class
  # @see Remix::ModuleExtensions#module_move_up
  def extended_module_move_up(mod)
    singleton_class.module_move_up(mod)
  end
  
  # Like `module_move_down()` but for the singleton class
  # @see Remix::ModuleExtensions#module_move_down
  def extended_module_move_down(mod)
    singleton_class.module_move_down(mod)
  end

  # Like `replace_module()` but for the singleton class
  # @see Remix::ModuleExtensions#replace_module_down
  def replace_extended_module(mod1, mod2)
    singleton_class.replace_module(mod1, mod2)
  end
end

module Remix::ModuleExtensions

  # Temporarily includes a module for the duration of a block.
  # Module will be unincluded at end of block.
  # @param [Module] mod Module to be temporarily included
  def temp_include(mod, &block)
    begin
      include(mod)
      yield
    ensure
      uninclude(mod, true)
    end
  end

  # Temporarily includes a module for the duration of a block in a
  # thread-safe manner.
  # Module will be unincluded at end of block.
  # @param [Module] mod Module to be temporarily included
  def temp_include_safe(mod, &block)
    safe_code = proc do
      begin
        include(mod)
        yield
      ensure
        uninclude(mod, true)
      end
    end
    
    if !@__exclusive__
      @__exclusive__ = true
      Thread.exclusive(&safe_code)
      remove_instance_variable(:@__exclusive__)
    else
      safe_code.call
    end
  end
end
  

# bring extend-based methods into Object  
class Object
  include Remix::ObjectExtensions
end

# bring include-based methods into Module
class Module
  include Remix::ModuleExtensions
end
