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

  def get_coor(ship)
    ship.row = ('a'..'j').to_a.sample
    ship.col = (1..10).to_a.sample
    ship.direction = ['h', 'v'].sample
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
    ship.col = square.length == 3 ? 10 : square[1]
  end

  def self.prompt_attack
    puts "Enter the coordinates of attack"
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
    place_ships(player.ships, 'human', player.board)
    place_ships(computer.ships, 'comp', computer.board)
    view.print_board(computer.board)
    attack
  end

  def attack
    check = false
    until check
    view.prompt_attack
    attack = gets.chomp
    row = computer.board.row_decoder[attack[0].upcase]
    col = attack.length == 3 ? 10 : attack[1].to_i
    if computer.board.board[row][col] == "*"
      puts "hit"
      computer.board.board[row][col] = "X"
      check = check_board(computer.board)
      view.print_board(computer.board)
    else
      puts "miss"
      computer.board.board[row][col] = "/"
      check = check_board(computer.board)
      view.print_board(computer.board)
    end
  end
  puts 'You Win!'
  end

  def check_board(board)
    !board.board.flatten.include?("*")
  end



  def place_ships(ships,player_type, board)
    ships.each do |ship|
      check = false
      while check==false
        player_type == 'human' ? view.prompt_user(ship) : computer.get_coor(ship)
        row = board.row_decoder[ship.row.upcase]
        col = ship.col.to_i
        if ship.direction[0] == "h"
          if board.board[row][col..col+ship.length].include?("*") || col+ship.length > 11
            puts "Can't place ship here"
            check = false
          else
            board.place_ship(ship)
            view.print_board(board) if player_type == 'human'
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
          if vert.include?("*") || ship.direction == ""
            puts "Can't place ship here"
            check = false
          else
            board.place_ship(ship)
            view.print_board(board) if player_type == 'human'
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
