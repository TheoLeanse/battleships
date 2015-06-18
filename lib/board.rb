require_relative './ship'
require_relative './player'

class Board
  attr_reader :grid, :hits, :misses, :row_size
  def initialize(row_size=10)
    @row_size = row_size
    @grid = create_grid #(row_size)
    @fleet, @hits, @misses = [], [], [] # initializing with three empty arrays - problem?
  end

  def create_grid #(length)
    grid_scaffold = Hash.new
    #grid_scaffold.default = fail "Cannot place ships off the board"
    (row_size**2).times { |index| grid_scaffold[index + 1] = 'unoccupied' }
    grid_scaffold
  end

  def place(ship, cell, direction)
    fail 'Incorrect direction' unless Board.private_method_defined?(direction)
    send(direction, ship, cell) if ship.size > 1
    check_space(cell)
    grid[cell] = ship
    @fleet << ship
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

  def all_sunk?
    @fleet.all? { |ship| ship.sunk? }
  end

  def cell_occupied?(cell)
    # should this be private?
    # What's the deal with private methods?
    # Will it stop the public methods from using it?
    # Shouldn't really, should it?
    # And is there a bug in here (regarding ship overlap?)
    grid[cell] != 'unoccupied' && grid[cell] != nil
    # how to return a Boolean if the hash's default error is raised?
  end


  private
  # any private readers / writers? such as fleet?
  def check_space(cell)
    fail "Space is occupied" if cell_occupied?(cell)
    fail "Cannot place ships off the board" unless grid.keys.include?(cell)
  end

  # consider making these directions methods into a separate class?
  # and encapaulate the logic for each cell move in each direction.
  def east(ship, cell)
    fail 'Ship cannot be placed here' if ship.size > (row_size + 1) - cell % row_size
    i = 1
    while i < ship.size # make into a proper ruby loop
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
end
