class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

pete = Pet.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

puts pete.run # => "running!"

begin
  puts pete.speak # => NoMethodError
rescue NoMethodError
  puts "NoMethodError"
end

puts kitty.run # => "running!"
puts kitty.speak # => "meow!"

begin
  puts kitty.fetch # => NoMethodError
rescue NoMethodError
  puts "NoMethodError"
end

puts dave.speak # => "bark!"

puts bud.run # => "running!"
puts bud.swim # => "can't swim!"

p Pet.ancestors
p Cat.ancestors
p Dog.ancestors
p Bulldog.ancestors
