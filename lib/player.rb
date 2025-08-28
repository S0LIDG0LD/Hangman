# frozen_string_literal: true

# This class is needed to initiate a player playing the game
class Player
  def initialize(game)
    @game = game
    @guess = ''
  end
end
