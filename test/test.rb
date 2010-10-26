require 'rubygems'
require '../lib/remix'
require 'bacon'

class Module
  public :include, :remove_const
end

describe 'Test basic remix functionality' do
  before do
    A = Module.new
    B = Module.new
    C = Module.new
    J = Module.new
    
    M = Module.new

    M.include A, B
  end

  describe 'include_after' do
    it 'should insert module into correct position' do
      M.include_after A, C
      M.ancestors[2].should == C
    end
  end

  describe 'include_before' do
    it 'should insert module into correct position' do
      M.include_before B, C
      M.ancestors[2].should == C
    end
  end

  describe 'include_at_top' do
    it 'should insert module at top of chain' do
      M.include_at_top C
      M.ancestors.last.should == C
    end
  end
  
  describe 'swap_modules' do
    it 'should interchange modules' do
      M.ancestors[1..2].should == [A, B]
      M.swap_modules A, B
      M.ancestors[1..2].should == [B, A]
    end
  end

  describe 'module_move_up' do
    it 'should move module up the chain' do
      M.ancestors[1..2].should == [A, B]
      M.module_move_up A
      M.ancestors[1..2].should == [B, A]
    end
  end

  describe 'module_move_down' do
    it 'should move module down the chain' do
      M.ancestors[1..2].should == [A, B]
      M.module_move_down B
      M.ancestors[1..2].should == [B, A]
    end
  end

  describe 'include_at' do
    it 'should include module at specified index' do
      M.include_at(1, C)
      M.ancestors[1].should == C
    end
  end

  describe 'remove_module' do
    it 'should remove the module' do
      M.ancestors[1..2].should == [A, B]
      M.remove_module A
      M.ancestors[1..2].should == [B]
    end

    it 'should remove recursively if second parameter is true' do
      klass = Module.new
      klass.include J, M, C
      klass.ancestors[1..-1].should == [J, M, A, B, C]
      klass.remove_module M, true
      klass.ancestors[1..-1].should == [J, C]
    end
  end

  describe 'replace_module' do
    it 'should replace the module with another' do
      M.ancestors[1..2].should == [A, B]
      M.replace_module B, C
      M.ancestors[1..2].should == [A, C]
    end
  end
  
  after do
    Object.remove_const(:A)
    Object.remove_const(:B)
    Object.remove_const(:C)
    Object.remove_const(:M)
  end
end
