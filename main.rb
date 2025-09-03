# frozen_string_literal: true

# main Ruby file
require_relative 'lib/player'
require_relative 'lib/game'
require_relative 'lib/human_player'
require_relative 'lib/constants'
# require_relative 'lib/gianna_ai_player'
require 'yaml'

def choose_save
  savegames = create_savegames_list
  savegames.each_with_index { |save, index| puts "#{index + 1}. #{save}" }
  print "\n#{Constants::PLAYER} chooses a save game to load: "
  save_game_number = gets.chomp.to_i
  savegames[save_game_number - 1]
end

def load_game(save_game)
  FileUtils.chdir "#{Constants::ROOT_DIR}/#{Constants::SAVES_FOLDER}"
  save_file = File.open(File.join(Dir.getwd, save_game), 'r')
  loaded_game = YAML.safe_load(save_file, permitted_classes: [Symbol])
  save_file.close
  loaded_game
end

def start_game
  print "\nLet's play..... SAVE the H A N G M A N !!!\n"
  return '1' unless savegames_found?

  puts "\n1) New Game"
  puts '2) Load Game'
  print "\nHumanoid chooses one game mode: "
  game_choice = gets.chomp
  until Constants::GAME_CHOICE.include?(game_choice)
    print 'Game mode not yet discovered. Humanoid chooses one of the discovered game modes: '
    game_choice = gets.chomp
  end
  game_choice
end

def savegames_found?
  savegames = create_savegames_list
  savegames.any?(/save/)
end

def create_savegames_list
  savegames = Dir.entries Constants::SAVES_FOLDER
  savegames.select! { |file| file[-5, 5] == '.save' }
end

loop do
  # new(data[:solution], data[:guess], data[:round])
  if start_game == '1'
    Game.new.play_game
  else
    loaded_game = load_game(choose_save)
    Game.new(loaded_game[:solution], loaded_game[:guess], loaded_game[:round]).play_game
  end
  print "\nPlay another game? (y/n) "
  return unless gets.chomp == 'y'
end
