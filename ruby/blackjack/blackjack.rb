class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card(index)
    @playable_cards.delete_at(index)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards, :game_deck

  def initialize
    @cards = []
    @game_deck = Deck.new
    2.times do 
      add_card
    end
    return @cards
  end

  def add_card
    random = rand(@game_deck.playable_cards.size)
    @cards << @game_deck.playable_cards[random]
    @game_deck.deal_card(random)
  end

end


class Player
  attr_accessor :my_hand, :type, :hand_value

  def initialize(type)
    @my_hand = Hand.new
    @type = type
  end

#tried to work smart around ace value logic :(
  def hand_value
    @hand_value = 0
    bust = false
    @my_hand.cards.each { |i| 
      if i.name == :ace
        if @hand_value <= 10
          @hand_value += i.value[0]
        else 
          @hand_value += i.value[1]
        end
      else
        @hand_value += i.value 
      end
    }
    return @hand_value
  end

  def blackjack?
    @blackjack = false
    hand_value
    if @hand_value == 21
      @blackjack = true
    end
    return @blackjack
  end

  def draw_card
    @my_hand.add_card
  end

  def bust?
    bust = false
    hand_value
    if @hand_value > 21
      bust = true
    end
    return bust
  end
end

#Making this a Dealer vs. User game for now
class Game
  attr_accessor :contenstants, :user, :dealer, :table, :winner

  def initialize
    @user = Player.new("user")
    @dealer = Player.new("dealer")
    @table = [@user, @dealer]
    @winner = nil
  end

  def check_winner
    @table.each { |i| 
      if i.blackjack?
        return winner = i
      end
    }
    if @user.bust?
      return winner = @dealer
    elsif @dealer.bust?
      return winner = @user
    end    
    return winner = nil
  end

#Think of efficient way to simulate this!
  def round
    @dealer.hand_value
    if @dealer.hand_value < 17
      @dealer.draw_card
    end
    if @user.hand_value <= 17 
      @user.draw_card
    end
  end

  def run

  end


end







require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.playable_cards[20]
    @deck.deal_card(20)
    assert_equal @deck.playable_cards.include?(card), false
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class HandTest < Test::Unit::TestCase
  def setup 
    @hand = Hand.new
  end

  def test_hand_should_initially_have_two_cards
    assert_equal @hand.cards.size, 2
  end

  def test_add_card_should_increase_size_of_card_collection
    @hand.add_card
    assert_equal @hand.cards.size, 3
  end
end

class PlayerTest < Test::Unit::TestCase
  def setup
    @playerUser = Player.new('user')
  end

  def test_player_has_initial_hand_of_two_cards
    assert(@playerUser.my_hand)
  end

  def test_player_is_aware_of_internal_hand_value
    assert(@playerUser.hand_value > 0 && @playerUser.hand_value <= 21)
  end

  def test_players_inital_hand_is_not_a_bust
    assert_equal @playerUser.bust?, false
  end
end

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
  end

  def test_game_has_2_players
    assert_equal @game.table.size,  2
  end

  def test_one_player_is_a_dealer_another_is_a_user
    assert(@game.table[0].type == "user" && @game.table[1].type == 'dealer')
  end

  def test_winner_of_the_game_is_decalred_when_simulated

  end

end




