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

  attr_accessor :board, :ships

  def initialize
    @ships = [Ship.new(5), Ship.new(3), Ship.new(4)]
    @board = Board.new
  end
end

class Computer
  attr_accessor :board, :ships

  def initialize
    @ships = [Ship.new(5), Ship.new(3), Ship.new(4)]
    @board = Board.new
  end
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
    ship.col = square.length == 3 ? square[1..2] : square[1]
  end

end

#CONTROLLER

class GameController

  attr_accessor :view, :player, :computer

  def initialize(arg={})
    @view = arg[:view]
    @player = arg[:player]
    @computer = arg[:computer]
  end

  def run
    view.print_board(player.board)
    self.place_ships(player.ships, 'human')
  end

  def place_ships(ships,player_type)
    ships.each do |ship|
      check = false
      while check==false
        view.prompt_user(ship) if player_type == 'human'
        row = player.board.row_decoder[ship.row.upcase]
        col = ship.col.to_i
        if ship.direction[0] == "h"
          if player.board.board[row][col..col+ship.length].include?("*") || col+ship.length > 11
            puts "Can't place ship here"
            check = false
          else
            player.board.place_ship(ship)
            view.print_board(player.board)
            check = true
          end
        else
          vert = []
          if row + ship.length > 11
            vert << "*"
          else
            ship.length.times do
              vert << player.board.board[row][col]
              row +=1
            end
          end
          if vert.include?("*")
            puts "Can't place ship here"
            check = false
          else
            player.board.place_ship(ship)
            view.print_board(player.board)
            check = true
          end
        end
      end
    end
  end

end

game = GameController.new({view: View,
                           player: Player.new,
                           computer: Computer.new})


game.run
