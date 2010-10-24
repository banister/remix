require 'mult'
require './remix'

class A
end

class B < A
end

class C < B
end

module M
end

module N
end

class C
  include M
  include N
end

