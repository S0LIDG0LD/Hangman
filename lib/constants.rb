# frozen_string_literal: true

# This class is used to contain all constants of the game
class Constants
  SAVES_FOLDER = 'saves'
  NUMBER_OF_ROUNDS = 12
  SHORTER_WORD_SIZE = 5
  LONGER_WORD_SIZE = 12
  WORDS_FILE_NAME = 'google-10000-english-no-swears.txt'
  MASTERMIND = 'Gianna AI'
  PLAYER = 'Humanoid'
  GAME_CHOICE = %w[1 2].freeze
  ROOT_DIR = File.expand_path('.')
end
