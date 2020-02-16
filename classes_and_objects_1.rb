class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_first_last_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_first_last_name(full_name)
  end

  def parse_first_last_name(name)
    parts = name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : ''
  end

  def to_s
    name
  end
end

bob = Person.new('Robert')
puts bob.name == 'Robert'
puts bob.first_name == 'Robert'
puts bob.last_name == ''
bob.last_name = 'Smith'
puts bob.name == 'Robert Smith'

bob.name = "John Adams"
puts bob.first_name == 'John'
puts bob.last_name == 'Adams'

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

puts bob.name == rob.name

puts "The person's name is: #{bob}"
