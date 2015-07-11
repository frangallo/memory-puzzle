require 'byebug'

class Card

  attr_reader :flipped

  def initialize(value)
    @value = value
    @flipped = false
  end

  def hide
    @flipped = false
  end

  def reveal
    @flipped = true
  end

  def to_s
    @flipped ? @value.to_s : '?'
  end

  def ==(other_card)
    return true if @value.to_s == other_card.to_s
    false
  end
end

class Board
  attr_reader :grid

  def initialize(size)
    @size = size
    @grid = Array.new(size) {Array.new(size)}
    @card_values = (0..size**2).to_a[0..((size**2 /2)-1)] * 2
    @card_values.shuffle!
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col,mark)
    @grid[row][col] = mark
  end

  def populate
    @size.times do |row|
      @size.times do |col|
        @grid[row][col] = Card.new(@card_values.pop)
      end
    end
     @grid
  end

  def render
    @size.times do |row|
      p @grid[row].map {|el| el.to_s }
    end
    puts ""
  end

  def won?
    @grid.each do |row|
      return false if row.any? { |card| card.flipped == false }
    end
    true
  end

  def reveal(pos)
    self[*pos].reveal
    self[*pos].to_s
  end

end


class Game

  def initialize(size,player)
    @board = Board.new(size)
    @guess_num = 0
    @size = size
    @player = player
    play
  end

  def self.start_prompt
    puts "Please enter the size of the board! Must be an even number!"
    @input = gets.chomp.to_i
    until @input % 2 == 0
      self.start_prompt
    end
    puts "Human or computer player? ('h' for human, 'c' for computer)"
    @player_input = gets.chomp.downcase
    until @player_input == 'c' || @player_input == 'h'
      puts "Human or computer player? ('h' for human, 'c' for computer)"
      @player_input = gets.chomp.downcase!
    end
    if @player_input == 'h'
      Game.new(@input,HumanPlayer.new)
    else
      Game.new(@input,ComputerPlayer.new(@input))
    end
  end

  def play
    puts "Welcome to Memory Puzzle!"
    @board.populate
    until @board.won? || @guess_num >= (@size**2)
      @board.render
      @guess_1 = @player.prompt
      until valid_guess_board?(@guess_1)
        @guess_1 = @player.prompt
      end
      @player.receive(@board.reveal(@guess_1))
      @board.render

      @guess_2 = @player.prompt
      until valid_guess_board?(@guess_2)
        @guess_2 = @player.prompt
      end
      @player.receive(@board.reveal(@guess_2))
      #@board.reveal(@guess_2)
      @board.render

      sleep(3)
      make_guess
    end
    puts "You won!" if @board.won?
    puts "You lost!" if @guess_num > (@size**2)
  end

  def make_guess
    unless @board[*@guess_1] == @board[*@guess_2]
      @board[*@guess_1].hide
      @board[*@guess_2].hide
    end
    @guess_num+=1
    system("clear")
  end

  def valid_guess_board?(guess)
    unless guess.length == 2 && guess.any? { |el| el.between?(0,@board.grid.length-1) }
      puts "Invalid Guess!!"
      return false
    end
    if @board[*guess].flipped
      puts "You've already guessed this!" if @player.is_a?(HumanPlayer)
      return false
    end
    true
  end

end

class HumanPlayer
  def prompt
    puts "Please enter in a row and column"
    gets.chomp.split(",").map!(&:to_i)
  end

  def receive(result)
  end

end

class ComputerPlayer
  def initialize(size)
    @prev_guesses = Hash.new()
    @indicies = (0..(size-1)).to_a
  end

  def prompt
    if @prev_guesses.empty?
      @guess = [@indicies.sample, @indicies.sample]
    elsif
      @pre_guesses.has_key?()
  end

  def receive(result)
    @prev_guesses[result] = @guess
  end




end




















def invoke
  Game.start_prompt
end

invoke if __FILE__ == $PROGRAM_NAME
