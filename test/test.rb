direc = File.dirname(__FILE__)
require 'rubygems'
require "#{direc}/../lib/remix"
require 'bacon'

class Array
  def sample(n = 1)
    shuffle.take(n)
  end if !method_defined?(:sample)
end

class Module
  public :include, :remove_const
end

puts "testing Remix version #{Remix::VERSION}..." 
puts "Ruby version: #{RUBY_VERSION}"

describe 'Test basic remix functionality' do
  before do
    A = Module.new { def hello; :hello; end }
    B = Module.new
    C = Module.new 
    J = Module.new
    
    M = Module.new

    M.include A, B
    M.extend A, B

    C1 = Class.new
    C2 = Class.new(C1)
    C2.include A
  end

  after do
    Object.remove_const(:A)
    Object.remove_const(:B)
    Object.remove_const(:C)
    Object.remove_const(:M)
    Object.remove_const(:J)
    Object.remove_const(:C1)
    Object.remove_const(:C2)
  end

  describe 'extend-based methods' do
    describe 'extend_after' do
      it 'should insert module into correct position in singleton class' do
        M.extend_above B, J
        M.singleton_class.ancestors
        M.singleton_class.ancestors[0..2].should == [A, B, J]
      end
    end

    describe 'temp_extend' do
      it 'should temporarily extend the module for the duration of a block' do
        lambda { B.hello }.should.raise NoMethodError
        B.temp_extend(A) do
          B.hello.should == :hello
        end
        lambda { B.hello }.should.raise NoMethodError
      end

      it 'should execute before and after hooks prior to and after running the temp_extend block' do
        lambda { B.hello }.should.raise NoMethodError
        B.instance_variable_defined?(:@before).should == false
        B.instance_variable_defined?(:@after).should == false
        B.temp_extend(A,
                      :before => proc { B.instance_variable_set(:@before, true) },
                      :after => proc { B.instance_variable_set(:@after, true) } ) do
          B.instance_variable_get(:@before).should == true
          B.instance_variable_defined?(:@after).should == false
          B.hello.should == :hello
        end
        B.instance_variable_get(:@after).should == true
        B.instance_variable_get(:@before).should == true
        lambda { B.hello }.should.raise NoMethodError
      end
      
      describe 'temp_extend_safe' do
        it 'should temporarily extend the module for the duration of a block in a threadsafe manner' do
          lambda { B.hello }.should.raise NoMethodError
          B.temp_extend_safe(A) do
            B.hello.should == :hello
          end
          lambda { B.hello }.should.raise NoMethodError
        end
      end
      
      describe 'unextend' do
        it 'should unextend the module' do
          C.include A, B
          M.extend C
          M.singleton_class.ancestors[0..2].should == [C, A, B]
          M.unextend C
          M.singleton_class.ancestors[0..1].should == [A, B]
        end

        it 'should unextend the nested module' do
          C.include A, B
          M.extend C
          M.extend J
          M.singleton_class.ancestors[0..3].should == [J, C, A, B]
          M.unextend C, true
          M.singleton_class.ancestors[0..1].should == [J, Module]
        end

        it 'should unextend the class of the object' do
          o = C2.new
          o.singleton_class.ancestors.first.should == C2
          o.unextend(C2)
          o.singleton_class.ancestors.first.should == A
        end
      end
      
      describe 'replace_extended_module' do
        it 'should replace the class of the object with a module' do
          o = C2.new
          o.singleton_class.ancestors.first.should == C2
          o.replace_extended_module C2, J
          o.singleton_class.ancestors.first.should == J
        end
      end
    end
    
    describe 'include-based methods' do
      describe 'include_after' do
        it 'should insert module into correct position' do
          M.include_after A, C
          M.ancestors[2].should == C
        end
      end

      describe 'temp_include' do
        it 'should temporarily include the module for the duration of a block' do
          lambda { "john".hello }.should.raise NoMethodError
          String.temp_include(A) do
            "john".hello.should == :hello
          end
          lambda { "john".hello }.should.raise NoMethodError
        end

        it 'should execute before and after hooks prior to and after running the temp_include block' do
          lambda { B.hello }.should.raise NoMethodError
          B.instance_variable_defined?(:@before).should == false
          B.instance_variable_defined?(:@after).should == false
          B.temp_include(A,
                        :before => proc { B.instance_variable_set(:@before, true) },
                        :after => proc { B.instance_variable_set(:@after, true) } ) do
            B.instance_variable_get(:@before).should == true
            B.instance_variable_defined?(:@after).should == false
          end
          B.instance_variable_get(:@after).should == true
          B.instance_variable_get(:@before).should == true
          lambda { B.hello }.should.raise NoMethodError
        end
        
      end

      describe 'temp_include_safe' do
        it 'should temporarily include the module for the duration of a block in a threadsafe manner' do
          lambda { "john".hello }.should.raise NoMethodError
          String.temp_include_safe(A) do
            "john".hello.should == :hello
          end
          lambda { "john".hello }.should.raise NoMethodError
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

        it 'should handle huge ancestor chains without crashing or returning the wrong result' do
          size = 100
          m = Module.new
          size.times do
            m.include Module.new
          end

          m.ancestors.size.should == size + 1
          size.times do
            m.swap_modules(m.ancestors[rand(size - 1) + 1],
                           m.ancestors[rand(size - 1) + 1])
          end
          m.ancestors.size.should == size + 1
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

        it 'should replace a class with a module' do
          C2.ancestors[0..2].should == [C2, A, C1]
          C2.replace_module C1, B
          C2.ancestors[0..2].should == [C2, A, B]
        end
      end
    end
  end
end
