# frozen_string_literal: true

# This class is needed to add a Human Player in the game
class HumanPlayer < Player
  def choose_letter!
    loop do
      @game.display_board
      round_number = "This is round #{@game.round} of #{@game.number_of_rounds}. "
      print "\n#{round_number}#{self} choose carefullty a letter: "
      guessed_letter = gets.chomp.upcase
      if guessed_letter.size == 1
        @game.round += 1
        return guessed_letter
      end
    end
  end

  def to_s
    'Humanoid'
  end
end
