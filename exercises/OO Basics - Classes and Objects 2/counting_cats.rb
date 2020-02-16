class Cat
  @@cat_counter = 0

  def initialize
    @@cat_counter += 1
  end

  def self.total
    puts @@cat_counter
  end
end

kitty1 = Cat.new
kitty2 = Cat.new

