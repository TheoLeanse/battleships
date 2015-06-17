require_relative './ship'
require_relative './player'

class Board
  attr_reader :grid, :hits, :misses, :row_size
  def initialize(row_size=10)
    @row_size = row_size
    @hits = []
    @misses = []
    @grid = create_grid(row_size)
  end

  def create_grid(length)
    grid_scaffold = Hash.new # create deafult value with error - if call a method that's off the board?
    (length**2).times { |index| grid_scaffold[index + 1] = 'unoccupied' }
    grid_scaffold
  end

  def place(ship, cell, direction)
    fail 'Incorrect direction' unless Board.private_method_defined?(direction)
    send(direction, ship, cell) if ship.size > 1
    check_space(cell)
    grid[cell] = ship
  end

  def cell_occupied?(cell) # should this be private?
    grid[cell] != 'unoccupied' && grid[cell] != nil
  end

  def hit(cell)
    fail 'Invalid guess (cell has already been hit)' if (hits + misses).include?(cell)
    fail "Invalid guess (cell does not exist)" unless grid.keys.include?(cell)
    if cell_occupied?(cell)
      grid[cell].hit
      hits << cell
    else
      misses << cell
    end
  end

  private
  def east(ship, cell)
    fail 'Ship cannot be placed here' if ship.size > (row_size + 1) - cell % row_size
    i = 1
    while i < ship.size
      check_space(cell + i)
      grid[cell + i] = ship
      i += 1
    end
  end

  def west(ship,cell)
    fail 'Ship cannot be placed here' if ship.size > cell % row_size
    i = 1
    while i < ship.size
      check_space(cell - i)
      grid[cell - i] = ship
      i += 1
    end
  end

  def south(ship,cell)
    fail 'Ship cannot be placed here' if ship.size > (110 - cell)/10
    i = 1
    j = 10
    while i < ship.size
      check_space(cell + j)
      grid[cell + j] = ship
      i += 1
      j += 10
    end
  end

  def north(ship, cell)
    fail 'Ship cannot be placed here' if ship.size > (cell / 10) + 1
    i = 1
    j = -10
    while i < ship.size
      check_space(cell - j)
      grid[cell + j] = ship
      i += 1
      j -= 10
    end
  end

  #private
  def check_space(cell)
    fail "Space is occupied" if cell_occupied?(cell)
    fail "Cannot place ships off the board" unless grid.keys.include?(cell)
  end
end
