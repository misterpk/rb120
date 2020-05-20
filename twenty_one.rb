require "byebug"

module Hand
  def hit(card)
    @cards.push(card)
  end

  def stay; end

  def busted?
    total > 21
  end

  def total
    @cards.reduce(0) { |total, card| total + card.value }
  end
end

class Player
  include Hand

  attr_accessor :hand

  def initialize
    @hand = []
  end
end

class Dealer < Player
end

class Deck
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
    show_initial_cards # done
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

  def player_turn
    # next
  end

  def dealer_turn; end

  def show_result; end
end

Game.new.start
