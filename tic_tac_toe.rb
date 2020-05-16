require "byebug"

class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
    [1, 5, 9], [3, 5, 7] # diagonals
  ]

  def initialize
    # We need some way to model the 3x3 grid. Maybe "squares"?
    # what data structure should we use?
    # - array/hash of Square objects?
    # - array/hash of strings or integeers
    # My thought - 3x3 multi-dimensional array
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = get_squares_from_line(line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def find_at_risk_square
    WINNING_LINES.each do |line|
      squares = get_squares_from_line(line)
      markers = get_markers_from_squares(squares)
      if markers.count(TTTGame::HUMAN_MARKER) == 2
        squares.each_with_index do |square, index|
          if square.unmarked?
            return line[index]
          end
        end
      end
    end
    nil
  end

  def find_winning_square
    WINNING_LINES.each do |line|
      squares = get_squares_from_line(line)
      markers = get_markers_from_squares(squares)
      if markers.count(TTTGame::COMPUTER_MARKER) == 2
        squares.each_with_index do |square, index|
          if square.unmarked?
            return line[index]
          end
        end
      end
    end
    nil
  end

  def reset
    (1..9).each { |index| @squares[index] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = get_markers_from_squares(squares)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def get_squares_from_line(line)
    @squares.values_at(*line)
  end

  def get_markers_from_squares(squares)
    squares.select(&:marked?).collect(&:marker)
  end
end

class Square
  attr_accessor :marker

  INITIAL_MARKER = " "

  def initialize(marker = INITIAL_MARKER)
    # maybe a "status" to keep track of this square's mark?
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def to_s
    marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    # maybe a "marker" to keep track of this player's symbol (ie, 'X' or 'O')
    @marker = marker
  end
end

class TTTGame
  attr_reader :board, :human, :computer
  attr_accessor :human_score, :computer_score

  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER
  WINNING_SCORE = 5

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
    @human_score = 0
    @computer_score = 0
  end

  def play
    clear
    display_welcome_message
    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      display_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear
    system "clear"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}"
    puts "Your score is #{human_score}. " \
         "The Computer's score is #{computer_score}"
    puts "The first player to win #{WINNING_SCORE} rounds wins the game!"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def human_moves
    puts "Choose a square between (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    winning_square = board.find_winning_square
    if winning_square
      return board[winning_square] = computer.marker
    end

    at_risk_square = board.find_at_risk_square
    if at_risk_square
      return board[at_risk_square] = computer.marker
    end

    board[board.unmarked_keys.sample] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      self.human_score += 1
      if human_score == WINNING_SCORE
        puts "You won #{WINNING_SCORE} games! You win!"
      else
        puts "You won the round!"
      end
    when computer.marker
      self.computer_score += 1
      if computer_score == WINNING_SCORE
        puts "The computer won #{WINNING_SCORE} games. The Computer wins!"
      else
        puts "Computer won the round!"
      end
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    if human_score == WINNING_SCORE || computer_score == WINNING_SCORE
      self.human_score = 0
      self.computer_score = 0
    end
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

# we'll kick off the game like this
game = TTTGame.new
game.play
