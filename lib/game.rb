# frozen_string_literal: true

# first class is the board with 9 editable spaces in a 3x3 matrix layout
# This class should also display the board status to the screen
class Game
  NUMBER_OF_ROUNDS = 12
  SHORTER_WORD = 5
  LONGER_WORD = 12
  attr_reader :solution
  attr_accessor :round

  def initialize(mastermind, player, dictionary_file)
    @mastermind = mastermind.new(self)
    @player = player.new(self)
    @dictionary = ingest(dictionary_file)
    game_title
    # puts @dictionary
    @solution = @dictionary.sample.upcase.chomp
    puts "The solution is #{@solution}"
    @guess = Array.new(@solution.size - 1, '_')
    @round = 1
  end

  def ingest(dictionary_file)
    exit unless File.exist? dictionary_file
    # puts File.readlines(dictionary_file).size
    File.readlines(dictionary_file).select { |word| word.chomp.size.between?(SHORTER_WORD, LONGER_WORD) }
  end

  def game_title
    print "\nLet's play..... H A N G M A N !!!\n"
    puts "\n#{@player} has #{NUMBER_OF_ROUNDS} rounds to guess the word or the Hangman won't be rescued!"
    # puts
    puts "\n#{@mastermind} choose a really tricky word, BEWARE!"
    # puts
  end

  def play_game
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
    guessed = @solution == @guess.join
    puts "\nCongratulations #{@player}! #{@player} guessed correctly the solution in #{@round - 1} rounds" if guessed
    # display_board
    guessed
  end

  def check(letter)
    # @solution.split.each_with_index { |char, index| @guess[index] = letter if char == letter }
    @solution.chars.each_with_index do |char, index|
      @guess[index] = letter if char == letter
    end
  end

  def adjusted_guess(guess)
    guess.split.reduce('') { |adjusted_guess, word| adjusted_guess + word.center(8) }
  end

  def display_board
    # puts
    puts "\nH A N G M A N : #{@guess.join(' ')}\n"
    # puts
  end

  def number_of_rounds
    NUMBER_OF_ROUNDS
  end
end
