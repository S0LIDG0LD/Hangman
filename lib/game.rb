# frozen_string_literal: true

# first class is the board with 9 editable spaces in a 3x3 matrix layout
# This class should also display the board status to the screen
class Game
  NUMBER_OF_ROUNDS = 8
  # HANGMAN = ['---', '|o o|', '---', 'o-----o', '/   |   \', 'o    |    o', '__/     |     \__', '-----', '|   |', '|   |', 'o   o', '|   |', '___|   |___'].freeze
  # SOLUTION_SIZE = 4
  SHORTER_WORD = 5
  LONGER_WORD = 12
  attr_reader :solution, :round

  def initialize(mastermind, player, dictionary)
    @mastermind = mastermind.new(self)
    @player = player.new(self)
    @dictionary = ingest(dictionary)
    puts @dictionary.size
    game_title
    @solution = @dictionary.sample
    puts "The solution is #{@solution}"
    @guess = string.new(@solution.size, '_')
    # puts "The secret combination to guess is: #{@solution}"
    @round = 1
    display_board
  end

  def ingest(dictionary)
    exit unless File.exist? dictionary
    puts File.readlines(dictionary)
    File.readlines(dictionary).select { |word| word.between?(SHORTER_WORD, LONGER_WORD) }
  end

  def game_title
    puts
    puts "#{@player} has 12 rounds to guess a combination of #{SOLUTION_SIZE} of these colors. Colors can be repeated!"
    puts COLORS.join(', ')
    puts
    puts "The Mastermind is #{@mastermind}, BEWARE!"
    puts
  end

  def create_random_solution
    solution = []
    SOLUTION_SIZE.times { solution.push(COLORS.sample) }
    solution.join(' ')
  end

  def play_game
    loop do
      return false unless can_play_round?

      # switch_players!
    end
  end

  def can_play_round?
    if @round > NUMBER_OF_ROUNDS
      puts "#{@player} had #{NUMBER_OF_ROUNDS} rounds to guess the solution, but #{@player} failed"
      puts
      false
    else
      guess = @player.make_guess!
      # puts "guess: #{guess}, solution: #{@solution}"
      return false if guessed?(guess)

      # @board_matrix[position[0] - 1][position[1] - 1] = player.symbol
      # display_board
      true
    end
  end

  def guessed?(guess)
    guessed = false
    last_round = []
    @guess = guess.split
    puts
    if guess == @solution
      puts "Congratulations #{@player}! #{@player} guessed correctly in #{@rounds_played.size + 1} rounds"
      # puts @rounds_played
      guessed = true
      result = 'X X X X'
      last_round.push(result)
      # guess.split.each do |item|
      #   word_and_result = []
      #   word_and_result.push(item)
      #   word_and_result.push('X')
      #   last_round.push(word_and_result)
      # end
    else
      puts "#{@player} has not guessed correctly. #{@player} has #{12 - @rounds_played.size - 1} more rounds to guess the solution"
      solution = @solution.split
      # puts solution
      last_round.push(check(guess, solution))
    end
    last_round.push(adjusted_guess(guess))
    # puts last_round
    @rounds_played.push(last_round)
    display_board(guessed)
    guessed
  end

  def check(guess, solution)
    # puts solution
    guess_to_check = guess.split
    result = []
    index_size = guess_to_check.size
    index = 0
    while index < index_size
      if guess_to_check[index] == solution[index]
        result.push('X')
        guess_to_check.delete_at(index)
        solution.delete_at(index)
        index_size -= 1
      else
        index += 1
      end
    end
    index = 0
    index_size = guess_to_check.size
    while index < index_size
      if solution.include?(guess_to_check[index])
        result.push('O')
        solution.delete(guess_to_check[index])
        guess_to_check.delete_at(index)
        index_size -= 1
      else
        result.push('-')
        index += 1
      end
    end
    result.shuffle.join(' ')
  end

  def display_result_line
    puts @rounds_played.last.join(' ')
  end

  # def display_border_line(size = 'long')
  #   if size == 'short'
  #     puts '               +---------------------------------+'
  #   else
  #     puts '+--------------+---------------------------------+'
  #   end
  # end

  # def reveal_solution
  #   puts "               | #{adjusted_guess(@solution)}|"
  # end

  # def adjusted_round_number(number)
  #   number < 10 ? " #{number}" : number.to_s
  # end

  # def display_rounds
  #   @rounds_played.reverse.each_with_index do |round, index|
  #     puts "| #{adjusted_round_number(@rounds_played.size - index)} | #{round[0]} | #{round[1]}|"
  #     display_border_line
  #   end
  # end

  def adjusted_guess(guess)
    guess.split.reduce('') { |adjusted_guess, word| adjusted_guess + word.center(8) }
  end

  def display_board
    puts
    # display_border_line('short')
    # if guessed
    #   reveal_solution
    # else
      puts "This is your guess number #{@round}: #{@guess}"
    # end
    # display_border_line
    display_rounds
    puts
  end

  # def adjust_string(word, length)
  # end

  # def player_won?(symbol)
  #   WINNING_CONDITIONS.each do |condition|
  #     won = true
  #     condition.each do |index|
  #       won &&= (@board_matrix.flatten[index - 1] == symbol)
  #     end
  #     return true if won == true
  #   end
  #   false
  # end

  # def game_won?(player)
  #   if player_won?(player.symbol)
  #     declare_winner(player)
  #     return true
  #   end
  #   false
  # end

  # def game_tied?
  #   if @board_matrix.flatten.none?(' ')
  #     puts 'The game is tied!'
  #     return true
  #   end
  #   false
  # end

  # def declare_winner(player)
  #   puts "#{player}#{@current_player_id + 1} won!"
  # end

  # def allowed_position?(row, col)
  #   @board_matrix[row][col] == ' '
  # end

  # def invalid_position(row, col)
  #   puts "There is already an #{@board_matrix[row - 1][col - 1]} at position #{row}, #{col}"
  # end
  #
  def current_round
    @rounds_played.size + 1
  end

  def number_of_rounds
    NUMBER_OF_ROUNDS
  end

  def number_of_colors
    SOLUTION_SIZE
  end
end
