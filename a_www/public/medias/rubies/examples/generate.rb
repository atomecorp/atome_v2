# generate new atome method example:

generate(:my_meth ) do |val|
  self.text ({ content: val, x: 12, y: 12} )
end
b=circle({x:333,y:333})
b.my_meth("I am created by a method created on the fly!!")