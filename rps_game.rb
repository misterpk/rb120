require 'byebug'

class Move
  VALUES = %w(rock paper scissors spock lizard)

  def self.create_move(move)
    case move
    when "rock"
      Rock.new
    when "paper"
      Paper.new
    when "scissors"
      Scissors.new
    when "spock"
      Spock.new
    when "lizard"
      Lizard.new
    end
  end

  def to_s
    self.class.to_s
  end
end

class Rock < Move
  def >(other_move)
    other_move.instance_of?(Scissors) || other_move.instance_of?(Lizard)
  end

  def <(other_move)
    other_move.instance_of?(Paper) || other_move.instance_of?(Spock)
  end
end

class Paper < Move
  def >(other_move)
    other_move.instance_of?(Rock) || other_move.instance_of?(Spock)
  end

  def <(other_move)
    other_move.instance_of?(Lizard) || other_move.instance_of?(Scissors)
  end
end

class Scissors < Move
  def >(other_move)
    other_move.instance_of?(Paper) || other_move.instance_of?(Lizard)
  end

  def <(other_move)
    other_move.instance_of?(Rock) || other_move.instance_of?(Spock)
  end
end

class Spock < Move
  def >(other_move)
    other_move.instance_of?(Scissors) || other_move.instance_of?(Rock)
  end

  def <(other_move)
    other_move.instance_of?(Paper) || other_move.instance_of?(Lizard)
  end
end

class Lizard < Move
  def >(other_move)
    other_move.instance_of?(Spock) || other_move.instance_of?(Paper)
  end

  def <(other_move)
    other_move.instance_of?(Scissors) || other_move.instance_of?(Rock)
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end

    self.name = n
  end

  def choose
    choice = nil

    loop do
      puts "Please choose #{Move::VALUES.join(', ')} or the first letter of " \
        "the move:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice"
    end

    self.move = Move.create_move(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Chappie", "Sonny", "Number 5"].sample
  end

  def choose
    self.move = Move.create_move(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  WINNING_SCORE = 10

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == "n"
    return true if answer.downcase == "y"
  end

  def play
    display_welcome_message
    loop do
      display_score
      human.choose
      computer.choose
      display_moves
      display_winner
      break if winning_score?
    end
    display_final_score
    display_goodbye_message
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      human.score += 1
      puts "#{human.name} won!"
    elsif human.move < computer.move
      computer.score += 1
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_goodbye_message
    puts "Thanks for playing #{Move::VALUES.map(&:capitalize).join(', ')}. " \
      "Good bye!"
  end

  def display_welcome_message
    puts "Welcome to #{Move::VALUES.map(&:capitalize).join(', ')}! " \
      "First player to #{WINNING_SCORE} wins!"
  end

  def display_score
    puts "Human Score: #{human.score}, Computer Score: #{computer.score}"
  end

  def winning_score?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def display_final_score
    if human.score == WINNING_SCORE
      puts "You scored #{WINNING_SCORE} points. You win!"
    else
      puts "Computer scored #{WINNING_SCORE} points. Computer wins!"
    end
  end
end

RPSGame.new.play
