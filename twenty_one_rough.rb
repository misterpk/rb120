require "byebug"

module Hand
  def hit(card)
    @hand.push(card)
  end

  def stay; end

  def busted?
    total > 21
  end

  def calculate_total
    @hand.reduce(0) { |total, card| total + card.value }
  end
end

class Player
  include Hand

  attr_accessor :hand, :state

  def initialize
    @hand = []
    @state = nil
  end
end

class Dealer < Player
end

class Deck
  # Why would I make the deck control the cards? Really the card is the object right? so it should know what kind
  # of things it could be? Why would the deck be the master controller?
  attr_reader :cards

  SUITS = %w(clubs diamonds hearts spades)
  CARDS = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  def initialize
    @cards = []
    SUITS.each do |suit|
      CARDS.each do |card|
        value = case card
                when "Ace"
                  11
                when "Jack", "Queen", "King"
                  10
                else
                  card.to_i
                end
        @cards << Card.new(suit: suit, name: card, value: value)
      end
    end
    @cards.shuffle!
  end

  def deal
    @cards.pop
  end
end

class Card
  attr_reader :suit, :name, :value

  def initialize(suit:, name:, value:)
    @suit = suit
    @name = name
    @value = value
  end
end

class Game
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    deal_cards # done
    show_initial_cards
    player_turn # next
    dealer_turn
    show_result
  end

  def deal_cards
    2.times do
      @player.hand.push(@deck.deal)
      @dealer.hand.push(@deck.deal)
    end
  end

  def show_initial_cards
    puts "Your cards: #{@player.hand[0].name} of #{@player.hand[0].suit}, " \
         "#{@player.hand[1].name} of #{@player.hand[1].suit}"
    puts "Total: #{@player.total}"
    puts ""
    puts "Dealer's cards: #{@dealer.hand[0].name} of " \
         "#{@dealer.hand[0].suit}, unknown"
  end

  def total(player)
    player.total
  end

  def player_turn
    player_move = nil
    loop do
      loop do
        puts "Would you like to (s)tay or (h)it? Enter s or h"
        player_move = gets.chomp.downcase
        break if %w(s h).include?(player_move)
        puts "Invalid entry. Please enter s or h"
      end
      if player_move == "s"
        break
      elsif player_move == "h"
        @player.hit(@deck.deal)
        puts "Total: #{total(@player)}"
        if total(@player) > 21
          @player.state = :busted
        end
        next
      end
    end
  end

  def dealer_turn
    until total(@dealer) >= 17
      @dealer.hit(@deck.deal)
    end
    if total(@dealer) > 21
      @dealer.state = :busted
    end
  end

  def show_result
    player_total = total(@player)
    dealer_total = total(@dealer)
    puts "Total: #{player_total}"
    puts "Dealer Total: #{dealer_total}"
    if @player.state == :busted
      puts "You busted. Dealer wins"
    elsif @dealer.state == :busted
      puts "Dealer busted. You win"
    elsif player_total > dealer_total
      puts "you win"
    elsif dealer_total > player_total
      puts "dealer wins"
    elsif dealer_total == player_total
      puts "it's a tie"
    end
  end
end

Game.new.start
