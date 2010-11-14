require 'set'

class Array
  def shuffle!
    size.downto(1) { |n| push delete_at(rand(n)) }
    self
  end

  def self.permuations(choices, permuation = [])
    return [permuation] if choices.empty?
    choices.first.inject([]) do |permuations, attribute|
      permuations + Array.permuations(choices[1, choices.length], permuation.dup << attribute)
    end
  end
end

class SetGame
  COLOURS = [:green, :red, :purple]
  SHAPES = [:peanut, :oval, :diamond]
  FILLS = [:solid, :hashed, :clear]
  NUMBERS = [:one, :two, :three]
  CHOICES = [COLOURS, SHAPES, FILLS, NUMBERS]

  def deck
    @deck ||= Array.permuations(CHOICES)
  end

  def deal!(number = 12)
    @deal = Set.new deck.shuffle!.first(number)
  end

  def deal(number = 12)
    @deal || deal!(number)
  end

  def self.print_cards(name, cards)
    puts "#{name}:"
    cards.each do |card|
      puts card.inspect
    end
    puts
  end

  def print
    SetGame.print_cards('Delt', deal)
  end

  def print_matches
    if cards = first_match
      SetGame.print_cards('First Match', cards)
    else
      puts 'No match found.'
    end
  end

  def first_match
    deal.each do |c1|
      (deal - [c1]).each do |c2|
        c3 = SetGame.matching_card(c1, c2)
        return [c1, c2, c3] if deal.include?(c3)
      end
    end
    nil
  end

  def self.matching_card(c1, c2)
    0.upto(3).map do |n|
      if c1[n] == c2[n]
        c1[n]
      else
        (CHOICES[n] - [c1[n], c2[n]]).first
      end
    end
  end
end

set_game = SetGame.new
set_game.print
set_game.print_matches

