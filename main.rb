# frozen_string_literal: true

# main Ruby file
require_relative 'lib/player'
require_relative 'lib/game'
require_relative 'lib/human_player'
require_relative 'lib/constants'
# require_relative 'lib/gianna_ai_player'

def choose_save
  puts
  @savegames.each_with_index { |save, index| puts "#{index + 1}. #{save}" }
  print "\n#{@player} chooses a save game to load: "
  save_game_number = gets.chomp.to_i
  @savegames[save_game_number - 1]
end

def load_game(save_game)
  FileUtils.chdir 'saves'
  puts Dir.getwd
  # save_file = File.read(@savegames[index])
  # # puts save_file
  # self.from_yaml(save_file)
  puts File.exist? save_game
  puts save_game
  save_file = File.open(File.join(Dir.pwd, save_game), 'r')
  puts save_file
  game = YAML.unsafe_load(save_file)
  save_file.close
  game
end

def start_game
  print "\nLet's play..... SAVE the H A N G M A N !!!\n"
  return '1' unless savegames_found?

  puts "\n1) New Game"
  puts '2) Load Game'
  print "\nHumanoid chooses one game mode: "
  game_choice = gets.chomp
  until Constants::NEW_GAME_CHOICE.include?(game_choice)
    print 'Game mode not yet discovered. Humanoid chooses one of the discovered game modes: '
    game_choice = gets.chomp
  end
end

def savegames_found?
  @savegames = Dir.entries Constants::SAVES_FOLDER
  @savegames.select! { |file| file[-5, 5] == '.save' }
  # puts @savegames
  @savegames.any?(/save/)
end

loop do
  game = start_game == 1 ? Game.new(HumanPlayer).play_game : load_game(choose_save)
  print "\nPlay another game? (y/n) "
  return unless gets.chomp == 'y'
end
