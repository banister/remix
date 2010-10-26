direc = File.dirname(__FILE__)

require 'rbconfig'
require "#{direc}/remix/version"

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

# bring in documentation of C methods
require "#{direc}/remix/c_docs"

module Kernel
  # :nodoc:
  def singleton_class
    class << self; self; end
  end if !respond_to?(:singleton_class)
end

module Remix::ObjectExtensions

  # Like `include_at()` but for the singleton class
  # @see Module#include_at
  def extend_at(index, mod)
    singleton_class.include_at(index, mod)
  end

  # Like `include_below()` but for the singleton class
  # @see Module#include_below
  def extend_below(mod)
    singleton_class.include_below(mod)
  end
  alias_method :extend_before, :extend_below

  # Like `include_above()` but for the singleton class
  # @see Module#include_above
  def extend_above(mod)
    singleton_class.include_above(mod)
  end
  alias_method :extend_after, :extend_above

  # Like `uninclude()` but for the singleton class
  # @see Module#uninclude
  def unextend(mod, recurse = false)
    singleton_class.uninclude(mod, recurse)
  end
  alias_method :remove_extended_module, :unextend

  # Like `include_at_top()` but for the singleton class
  # @see Module#include_at_top
  def extend_at_top(mod)
    singleton_class.include_at_top(mod)
  end

  # Like `swap_modules()` but for the singleton class
  # @see Module#swap_modules
  def swap_extended_modules(mod1, mod2)
    singleton_class.swap_modules(mod1, mod2)
  end

  # Like `module_move_up()` but for the singleton class
  # @see Module#module_move_up
  def extended_module_move_up(mod)
    singleton_class.module_move_up(mod)
  end
  
  # Like `module_move_down()` but for the singleton class
  # @see Module#module_move_down
  def extended_module_move_down(mod)
    singleton_class.module_move_down(mod)
  end

  # Like `replace_module()` but for the singleton class
  # @see Module#replace_module_down
  def replace_extended_module(mod1, mod2)
    singleton_class.replace_module(mod1, mod2)
  end
end

  
class Object
  include Remix::ObjectExtensions
end
