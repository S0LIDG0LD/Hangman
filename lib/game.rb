# frozen_string_literal: true

require 'yaml'
require 'fileutils'
# first class is the board with 9 editable spaces in a 3x3 matrix layout
# This class should also display the board status to the screen
class Game
  attr_reader :solution, :guess, :round

  def initialize(solution = nil, guess = nil, round = nil)
    @solution = solution.nil? ? pick_word_from_dictionary : solution
    @guess = guess.nil? ? '_ ' * @solution.size : guess
    @round = round.nil? ? 1 : round
    puts "\n#{Constants::PLAYER} has #{Constants::NUMBER_OF_ROUNDS - @round.to_i + 1} rounds to guess the word or the Hangman won't be rescued!"
  end

  def choose_letter!
    loop do
      display_board
      round_number = "This is round #{@round} of #{Constants::NUMBER_OF_ROUNDS}. "
      print "\n#{round_number}#{Constants::PLAYER} does want to save and exit the game? (y/n): "
      saving = gets.chomp.downcase == 'y'
      if saving
        save
      else
        print "\nChoose carefullty a letter: "
        guessed_letter = gets.chomp.upcase
        if guessed_letter.size == 1
          @round += 1
          return guessed_letter
        end
      end
    end
  end

  def pick_word_from_dictionary
    exit unless File.exist? Constants::WORDS_FILE_NAME
    dictionary = File.readlines(Constants::WORDS_FILE_NAME).select { |word| allowed?(word) }
    puts "\n#{Constants::MASTERMIND} choose a really tricky word, BEWARE!"
    dictionary.sample.upcase.chomp
  end

  def allowed?(word)
    word.chomp.size.between?(Constants::SHORTER_WORD_SIZE, Constants::LONGER_WORD_SIZE)
  end

  def to_yaml
    YAML.dump({
                solution: @solution,
                guess: @guess,
                round: @round
              })
  end

  def save
    puts FileUtils.getwd
    unless FileUtils.getwd == Constants::ROOT_DIR
      FileUtils.makedirs("#{Constants::ROOT_DIR}/#{Constants::SAVES_FOLDER}")
    end
    FileUtils.cd("#{Constants::ROOT_DIR}/#{Constants::SAVES_FOLDER}")
    f = File.new "#{Time.now}.save", 'w'
    # File.open(f)
    f << to_yaml
    f.close
    puts 'Your game has been saved. Thanks for playing!'
    exit
  end

  def play_game
    loop do
      if @round > Constants::NUMBER_OF_ROUNDS
        puts "\n#{Constants::PLAYER} had #{Constants::NUMBER_OF_ROUNDS} rounds to guess the solution, but #{Constants::PLAYER} failed\n"
        puts "\nThe H A N G M A N is D E A D"
        return
      elsif guessed_with?(choose_letter!)
        return
      end
    end
  end

  def guessed_with?(letter)
    check(letter)
    guessed = @solution == @guess.delete(' ')
    puts "\nCongratulations #{Constants::PLAYER}! #{Constants::PLAYER} guessed correctly the #{@solution} in #{@round - 1} rounds" if guessed
    guessed
  end

  def check(letter)
    @solution.chars.each_with_index do |char, index|
      @guess[(index * 2)] = letter if char == letter
    end
  end

  def adjusted_guess(guess)
    guess.split.reduce('') { |adjusted_guess, word| adjusted_guess + word.center(8) }
  end

  def display_board
    puts "\nH A N G M A N : #{@guess}\n"
  end
end
