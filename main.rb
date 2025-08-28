# frozen_string_literal: true

# main Ruby file
require_relative 'lib/player'
require_relative 'lib/game'
require_relative 'lib/human_player'
require_relative 'lib/gianna_ai_player'

loop do
  Game.new(GiannaAIPlayer, HumanPlayer, 'google-10000-english-no-swears.txt').play_game
  print 'Play another game? (y/n) '
  return unless gets.chomp == 'y'
end
