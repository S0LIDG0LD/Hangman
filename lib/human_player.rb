# frozen_string_literal: true

# This class is needed to add a Human Player in the game
class HumanPlayer < Player
  def choose_letter!
    loop do
      @game.display_board
      round_number = "This is round #{@game.round} of #{Constants::NUMBER_OF_ROUNDS}. "
      print "\n#{round_number}#{self} does want to save and exit the game? (y/n): "
      saving = gets.chomp.downcase == 'y'
      if saving
        @game.save
      else
        print "\nChoose carefullty a letter: "
        guessed_letter = gets.chomp.upcase
        if guessed_letter.size == 1
          @game.update_round
          return guessed_letter
        end
      end
    end
  end

  def to_s
    'Humanoid'
  end
end
