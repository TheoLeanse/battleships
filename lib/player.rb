class Player
  def initialize (board)
    @board = board
  end

  def place_ship(ship, cell, direction)
    @board.place(ship, cell, direction)
  end
end
