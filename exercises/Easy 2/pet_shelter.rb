require 'byebug'
require 'awesome_print'

class Pet
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end
end

class Owner
  attr_reader :pets, :name

  def initialize(name)
    @name = name
    @pets = []
  end

  def adopt_pet(pet)
    @pets << pet
  end

  def number_of_pets
    @pets.size
  end
end

class Shelter
  attr_reader :adoptions

  def initialize
    @adoptions = {}
    @available_pets = []
  end

  def adopt(owner, pet)
    owner.adopt_pet(pet)
    adopt_out_pet(pet)
    if @adoptions.key?(owner.name)
      @adoptions[owner.name].concat([pet])
    else
      @adoptions[owner.name] = [pet]
    end
  end

  def add_pet(pet)
    if pet.class == Array
      @available_pets += pet
    else
      @available_pets << pet
    end
  end

  def adopt_out_pet(pet)
    @available_pets.delete(pet)
  end

  def print_adoptions
    @adoptions.each do |key, value|
      puts "#{key} has adopted the following pets:"
      value.each do |pet|
        puts "a #{pet.type} named #{pet.name}"
      end
      puts
    end
  end

  def print_available_pets
    if @available_pets.empty?
      return puts "The Animal Shelter has no available pets"
    end
    puts "The Animal Shelter has the following unadopted pets:"
    @available_pets.each do |pet|
      puts "a #{pet.type} named #{pet.name}"
    end
    puts
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
mikey        = Pet.new('dog', 'Mikey')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.add_pet([butterscotch, pudding, darwin, kennedy,
                 sweetie, molly, chester, mikey])

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_adoptions
shelter.print_available_pets

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
