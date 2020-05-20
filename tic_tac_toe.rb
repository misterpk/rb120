class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
    [1, 5, 9], [3, 5, 7] # diagonals
  ]

  def initialize
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

  def [](key)
    @squares[key]
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

  def find_square_to_mark(marker)
    WINNING_LINES.each do |line|
      squares = get_squares_from_line(line)
      markers = get_markers_from_squares(squares)
      if markers.count(marker) == 2
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
  attr_accessor :name, :position, :score

  def initialize(marker:, name: nil)
    @marker = marker
    @name = name
    @position = position
    @score = 0
  end
end

class TTTGame
  attr_reader :board, :human, :computer, :current_marker

  DEFAULT_COMPUTER_MARKER = "O"
  CHOOSE = :choose
  HUMAN = :human
  COMPUTER = :computer
  # Select PLAYER, COMPUTER or CHOOSE. CHOOSE asks the player who goes first
  FIRST_TO_MOVE = CHOOSE
  WINNING_SCORE = 5

  def initialize
    @board = Board.new
    @human = nil
    @computer = nil
    @current_marker = nil
  end

  def play
    display_welcome_message
    setup_player_data

    play_game

    display_goodbye_message
  end

  private

  def play_game
    loop do
      clear_screen_and_display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      update_score
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def setup_player_data
    create_human_player
    create_computer_player
    select_player_to_move_first(FIRST_TO_MOVE)
  end

  def display_welcome_message
    clear
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def enter_player_name
    puts "Enter a name for the player:"
    gets.chomp.capitalize
  end

  def enter_player_marker
    puts "Enter a letter to use as your marker:"
    player_marker = nil
    loop do
      player_marker = gets.chomp.upcase
      break if player_marker.size == 1 && player_marker.match?(/[a-zA-Z]/)
      puts "Sorry, that's not a single letter."
    end
    player_marker
  end

  def create_human_player
    @human = Player.new(name: enter_player_name, marker: enter_player_marker)
  end

  def enter_computer_name
    puts "Enter a name for the computer:"
    gets.chomp.capitalize
  end

  def create_computer_player
    @computer = Player.new(marker: DEFAULT_COMPUTER_MARKER,
                           name: enter_computer_name)
  end

  def select_player_to_move_first(type = CHOOSE)
    case type
    when HUMAN
      human_has_first_move
    when COMPUTER
      computer_has_first_move
    when CHOOSE
      setup_player_to_move_first(enter_player_choice)
    end
  end

  def setup_player_to_move_first(player)
    if human_selected?(player)
      human_has_first_move
    elsif computer_selected?(player)
      computer_has_first_move
    end
  end

  def human_selected?(player)
    player == human.name[0].downcase || player == human.name.downcase
  end

  def computer_selected?(player)
    player == computer.name[0].downcase || player == computer.name.downcase
  end

  def enter_player_choice
    puts "Should #{human.name} or #{computer.name} move first?"
    player_to_move_first = nil

    loop do
      player_to_move_first = gets.chomp.downcase
      break if valid_player_selection(player_to_move_first)
      puts "Sorry, that's not a valid choice."
    end
    player_to_move_first
  end

  def valid_player_selection(player)
    [
      human.name,
      human.name[0],
      computer.name,
      computer.name[0]
    ].map(&:downcase).include?(player)
  end

  def human_has_first_move
    human.position = 1
    computer.position = 2
    @current_marker = human.marker
  end

  def computer_has_first_move
    computer.position = 1
    human.position = 2
    @current_marker = computer.marker
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear
    system "clear"
  end

  def display_board
    puts "You're \"#{human.marker}\". Computer is a \"#{computer.marker}\""
    puts "You: #{human.score}. Computer: #{computer.score}"
    puts "The first player to #{WINNING_SCORE} wins the game!" unless game_won?
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
    winning_square = board.find_square_to_mark(computer.marker)
    at_risk_squre = board.find_square_to_mark(human.marker)

    square = if winning_square
               winning_square
             elsif at_risk_squre
               at_risk_squre
             elsif board[5].unmarked?
               5
             else
               board.unmarked_keys.sample
             end

    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def update_score
    winning_marker = board.winning_marker
    winning_marker == human.marker ? human.score += 1 : computer.score += 1
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      display_human_won_message
    when computer.marker
      display_computer_won_message
    else
      puts "It's a tie!"
    end
  end

  def display_human_won_message
    if human_won?
      clear_screen_and_display_board
      puts "You won #{WINNING_SCORE} rounds! You win the game!"
    else
      puts "You won the round!"
    end
  end

  def display_computer_won_message
    if computer_won?
      clear_screen_and_display_board
      puts "The computer won #{WINNING_SCORE} rounds. " \
             "The Computer wins the game!"
    else
      puts "Computer won the round!"
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
    @current_marker = human.position == 1 ? human.marker : computer.marker
    if game_won?
      human.score = 0
      computer.score = 0
    end
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def human_won?
    human.score == WINNING_SCORE
  end

  def computer_won?
    computer.score == WINNING_SCORE
  end

  def game_won?
    human_won? || computer_won?
  end
end

# we'll kick off the game like this
game = TTTGame.new
game.play
