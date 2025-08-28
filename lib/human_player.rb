# frozen_string_literal: true

# This class is needed to add a Human Player in the game
class HumanPlayer < Player
  def make_guess!
    loop do
      round_number = "This is round #{@game.round} of #{@game.number_of_rounds}. "
      print "#{round_number}Choose a letter: "
      guessed_letter = gets.chomp
      return guessed_letter if guessed_letter.size == 1
    end
  end

  def to_s
    'Humanoid'
  end
end
