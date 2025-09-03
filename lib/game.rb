# frozen_string_literal: true

require 'yaml'
require 'fileutils'
# first class is the board with 9 editable spaces in a 3x3 matrix layout
# This class should also display the board status to the screen
class Game
  attr_reader :player, :solution, :guess, :round

  # attr_reader :mastermind, :player, :dictionary, :solution, :guess, :round
  # attr_accessor :round

  def initialize(player, savegames: nil, solution: nil, guess: nil, round: nil)
    # @mastermind = mastermind.new(self)
    @player = player.new(self)
    @savegames = savegames.nil? ? [] : savegames
    puts @savegames
    @solution = solution.nil? ? pick_dictionary_word : solution
    puts "The solution is #{@solution}"
    @guess = guess.nil? ? Array.new(@solution.size, '_').join(' ') : guess
    @round = round.nil? ? 1 : round
    puts "\n#{Constants::PLAYER} has #{Constants::NUMBER_OF_ROUNDS - @round.to_i + 1} rounds to guess the word or the Hangman won't be rescued!"
  end

  def pick_dictionary_word
    exit unless File.exist? DICTIONARY_FILE
    dictionary = File.readlines(DICTIONARY_FILE).select { |word| word.chomp.size.between?(SHORTER_WORD, LONGER_WORD) }
    dictionary.sample.upcase.chomp
    puts "\n#{Constants::MASTERMIND} choose a really tricky word, BEWARE!"
  end

  def update_round
    @round += 1
  end

  def to_yaml
    YAML.dump({
                # mastermind: @mastermind,
                player: @player,
                # dictionary: @dictionary,
                savegames: @savegames,
                solution: @solution,
                guess: @guess,
                round: @round
              })
  end

  # def self.from_yaml(string)
  #   data = YAML.safe_load string
  #   # data = YAML.load_file string
  #   # p data
  #   self.new(data[:mastermind], data[:player], data[:dictionary], data[:solution], data[:guess], data[:round])
  #   # new(data[:solution], data[:guess], data[:round])
  # end

  # def from_yaml(string)

  #   puts string
  #   # puts File.exist? string
  #   data = YAML.safe_load string
  #   new(data[:mastermind], data[:player], data[:dictionary], data[:solution], data[:guess], data[:round])
  #   puts @solution
  #   puts @guess
  #   puts @round
  #   # data = YAML.load_file string
  #   # p data

  #   # new(data[:solution], data[:guess], data[:round])
  # end

  def save
    FileUtils.makedirs(SAVES_FOLDER)
    FileUtils.cd(SAVES_FOLDER) unless FileUtils.getwd == 'saves'
    f = File.new "#{Time.now}.save", 'w'
    # File.open(f)
    f << to_yaml
    f.close
    exit
  end

  def play_game
    # choose_save if savegames_found?
    loop do
      if @round > NUMBER_OF_ROUNDS
        puts "\n#{@player} had #{NUMBER_OF_ROUNDS} rounds to guess the solution, but #{@player} failed\n"
        puts "\nThe H A N G M A N is D E A D"
        return
      elsif guessed_with?(@player.choose_letter!)
        return
      end
    end
  end

  def guessed_with?(letter)
    check(letter)
    puts @solution
    puts @guess
    guessed = @solution == @guess
    puts "\nCongratulations #{@player}! #{@player} guessed correctly the solution in #{@round - 1} rounds" if guessed
    # display_board
    guessed
  end

  def check(letter)
    # @solution.split.each_with_index { |char, index| @guess[index] = letter if char == letter }
    puts @guess
    temp_guess = @guess.split
    puts temp_guess
    @solution.chars.each_with_index do |char, index|
      temp_guess[index] = letter if char == letter
    end
    @guess = temp_guess.join(' ')
    puts @guess # @guess.join(' ')
  end

  def adjusted_guess(guess)
    guess.split.reduce('') { |adjusted_guess, word| adjusted_guess + word.center(8) }
  end

  def display_board
    # puts
    # puts "\nH A N G M A N : #{@guess.join(' ')}\n"
    puts "\nH A N G M A N : #{@guess}\n"
    # puts
  end

  def number_of_rounds
    NUMBER_OF_ROUNDS
  end
end
