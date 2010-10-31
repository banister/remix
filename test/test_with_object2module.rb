direc = File.dirname(__FILE__)
require 'rubygems'
require 'bacon'
require 'object2module'
require "#{direc}/../lib/remix"

class Module
  public :include, :remove_const
end

puts "testing Remix version #{Remix::VERSION} with Object2module version #{Object2module::VERSION}..."
puts "Ruby version: #{RUBY_VERSION}"

describe Remix do
  before do
    class A
      def hello
        :a
      end
    end

    class B
      def hello
        :b
      end
    end

    module M
      def m
        :m
      end
    end

    O = Object.new
    class << O
      def o
        :o
      end
    end

    C = Class.new
  end

  after do
    Object.remove_const(:A)
    Object.remove_const(:B)
    Object.remove_const(:C)
    Object.remove_const(:M)
    Object.remove_const(:O)
  end

  describe 'gen_include' do
    it 'includes two classes and swaps them' do
      C.gen_include A
      C.gen_include B
      C.new.hello.should == :b
      C.swap_modules A, B
      C.new.hello.should == :a
    end

    it 'includes a class into a class and swaps them' do
      A.gen_include B
      C.gen_include A
      C.new.hello.should == :a
      C.swap_modules A, B
      C.new.hello.should == :b
    end

    it 'unincludes a gen_included class' do
      C.gen_include A
      C.new.hello.should == :a
      C.uninclude A
      lambda { C.new.hello }.should.raise NameError
    end

    it 'recursively unincludes a gen_included class' do
      A.gen_include B
      C.gen_include A
      C.new.hello.should == :a
      C.ancestors.should[0..2] == [C, A, B]
      C.uninclude A, true
      C.ancestors.should[0..1] == [C, Object]
    end

    it 'unincludes a singleton class' do
      o = Object.new
      class << o
        def hello
          :o
        end
      end

      C.gen_include o
      C.new.hello.should == :o
      C.uninclude C.ancestors[1]
      lambda { C.new.hello }.should.raise NameError
      C.ancestors[1].should == Object
    end
  end

  describe 'gen_extend' do
    it 'extends two classes into an object and swaps them' do
      o = Object.new
      o.gen_extend A, B
      o.hello.should == :a
    end

    it 'unextends a class from an object' do
      o = Object.new
      o.gen_extend A
      o.hello.should == :a
      o.singleton_class.ancestors[0].should == A
      o.unextend A
      lambda { o.hello }.should.raise NameError
      o.singleton_class.ancestors[0].should == Object
    end

    it 'recursively unextends a class from an object' do
      o = Object.new
      A.gen_include B
      o.gen_extend A
      o.singleton_class.ancestors[0..2].should == [A, B, Object]
      o.unextend A, true
      o.singleton_class.ancestors.first.should == Object
    end

    it 'unextends an object by object (not by singleton)' do
      o = Object.new
      def o.hello
        :o
      end

      n = Object.new
      n.gen_extend o
      n.hello.should == :o
      n.unextend o
      lambda { n.hello }.should.raise NameError
    end


    it 'recursively unextends a singleton class gen_extended into another singleton class' do
      o = Object.new
      def o.hello
        :o
      end

      n = Object.new
      def n.hello
        :n
      end

      n.gen_extend o

      v = Object.new
      v.gen_extend n
      
      v.hello.should == :n
      v.unextend n.singleton_class,  true
      lambda { v.hello }.should.raise NameError
      v.singleton_class.ancestors.first.should == Object
    end
  end
end
