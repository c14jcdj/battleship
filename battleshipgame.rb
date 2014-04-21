#MODELS
require 'debugger'
class Board

  attr_accessor :board, :row_decoder

  def initialize
    @board =[[nil,  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ],
             [  "A",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "B",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "C",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "D",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "E",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "F",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "G",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "H",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "I",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
             [  "J", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ] ]
    a = (1..10).to_a
    b = %w(A B C D E F G H I J)
    @row_decoder =  Hash[b.zip(a)]
  end

  def place_ship(ship)
    row = row_decoder[ship.row.upcase]
    col = ship.col.to_i
    if ship.direction[0].downcase == "h"
      ship.length.times do
        board[row][col] = '*'
        col += 1
      end
    else
      ship.length.times do
        board[row][col] = '*'
        row +=1
      end
    end
  end

end

class Ship

  attr_accessor :length, :row, :col, :direction

  def initialize(length, row=nil, col=nil, direction=nil)
    @length = length
    @row = row
    @col = col
    @direction = direction
  end

end

class Player
end

class Computer
end

#VIEW

class View

  def initialize
    @square = nil
    @direction = nil
  end

  def self.print_board(board)
    board.board.each do |x|
      x.each do |y|
        print "#{y}\t"
      end
      puts
    end
  end

  def self.prompt_user(ship)
    puts "On what square would you like to place your first ship?"
    square = gets.chomp
    puts "What direction would you like your ship to go?"
    ship.direction = gets.chomp
    ship.row = square[0]
    ship.col = square[1]
  end

end

#CONTROLLER

class GameController

  attr_accessor :view, :board, :player, :computer, :ships

  def initialize(arg={})
    @view = arg[:view]
    @board = arg[:board]
    @ship1 = arg[:ships][:ship1]
    @ship2 = arg[:ships][:ship2]
    @ship3 = arg[:ships][:ship3]
    @player = arg[:player]
    @computer = arg[:computer]
    @ships = [@ship1, @ship2,@ship3]
  end

  def run
    view.print_board(board)
    self.place_ships(ships)
  end

  def place_ships(ships)
    ships.each do |ship|
      check = false
      while check==false
        view.prompt_user(ship)
        row = board.row_decoder[ship.row.upcase]
        col = ship.col.to_i
        if ship.direction[0] == "h"
          if board.board[row][col..col+ship.length].include?("*") || col+ship.length > 11
            puts "Can't place ship here"
            check = false
          else
            board.place_ship(ship)
            view.print_board(board)
            check = true
          end
        else
          vert = []
          if row + ship.length > 11
            vert << "*"
          else
            ship.length.times do
              vert << board.board[row][col]
              row +=1
            end
          end
          if vert.include?("*")
            puts "Can't place ship here"
            check = false
          else
            board.place_ship(ship)
            view.print_board(board)
            check = true
          end
        end
      end
    end
  end

end

game = GameController.new({view: View,
                           board: Board.new,
                           ships: {ship1: Ship.new(5), ship2: Ship.new(3), ship3: Ship.new(4)},
                           player: Player.new,
                           computer: Computer.new})


game.run
