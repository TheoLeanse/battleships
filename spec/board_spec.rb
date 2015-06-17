require 'board'


describe Board do

  it "has a grid" do
    expect(subject).to respond_to(:grid)
  end

  it "knows if a cell of the grid is occupied" do
    expect(subject.grid[1]).to eq('unoccupied')
  end

  it "responds to #cell_occupied?" do
    expect(subject).to respond_to(:cell_occupied?)
  end

  it "has a #place method taking three arguments" do
    expect(subject).to respond_to(:place).with(3).arguments
  end

  it "checks that a given location is on the board" do
    expect(subject.grid.keys).to include 1
  end

  it 'has a #create_grid method' do
    expect(subject).to respond_to(:create_grid).with(1).argument
  end

  it 'responds to misses' do
    expect(subject).to respond_to(:misses)
  end

  it 'responds to hits' do
    expect(subject).to respond_to(:hits)
  end

  describe 'hit' do

    it 'can be called with one argument' do
      expect(subject).to respond_to(:hit).with(1).argument
    end

    it 'changes a ship status' do
      ship = double :ship , size: 1
      board = Board.new
      board.place(ship,1,:east)
      expect(ship).to receive :hit
      board.hit(1)
    end

    it 'adds to an array of hits' do
      ship = double :ship , size: 1, hit: true
      board = Board.new
      board.place(ship,1,:east)
      board.hit(1)
      expect(board.hits).to eq [1]
    end

    it 'adds to an array of misses' do
      subject.hit(1)
      expect(subject.misses).to eq [1]
    end

    it 'throws an error for repeated guesses' do
      subject.hit(1)
      expect { subject.hit(1) }.to raise_error "Invalid guess (cell has already been hit)"
    end

  end


  describe 'create_grid' do

    it 'creates a hash containing each cell and its status' do
      hash = {1 => 'unoccupied', 2 => 'unoccupied', 3 => 'unoccupied', 4 => 'unoccupied'}
      expect(subject.create_grid(2)).to eq hash
    end

  end


  describe "cell_occupied?" do

    it "returns true when a given cell is occupied" do
      ship = double :ship, size: 1
      subject.place(ship, 1, :east)
      expect(subject.cell_occupied? 1).to eq(true)
    end

    it "returns false when a given cell is unoccupied" do
      expect(subject.cell_occupied? 1).to eq(false)
    end

  end


  describe "#place" do

    it "raises an error if attempting to place a ship in an occupied space" do
      ship = double :ship, size: 1
      subject.place(ship, 1, :east)
      expect { subject.place(:ship, 1, :east) }.to raise_error 'Space is occupied'
    end

    it "raises an error if attempting to place a ship in a non-existent cell" do
      expect { subject.place(:ship, subject.grid.length + 1, :east) }.to raise_error 'Cannot place ships off the board'
    end


    context 'when given a ship of size greater than one' do

      it 'places the ship over multiple cells (east)' do
        board = Board.new
        ship = double :ship, size: 2
        board.place(ship, 1, :east)
        expect(board.grid[2]).to eq ship
      end

      it 'places the ship over multiple cells (west)' do
        board = Board.new
        ship = double :ship, size: 5
        board.place(ship, 5, :west)
        expect(board.grid[1]).to eq ship
      end

      it 'raises an error when out of bounds from west end' do
        board = Board.new
        ship = double :ship, size: 5
        expect{board.place(ship, 4, :west)}.to raise_error 'Ship cannot be placed here'
      end

      it 'places the same ship over multiple cells (south)' do
        board = Board.new
        ship = double :ship, size: 5
        board.place(ship, 51, :south)
        expect(board.grid[91]).to eq ship
      end

      it 'raises an error when trying to place a ship out of bounds (soutward)' do
        board = Board.new
        ship = double :ship, size: 5
        expect { board.place(ship, 61, :south) }.to raise_error "Ship cannot be placed here"
      end

      it 'places the same ship over multiple cells (north)' do
        board = Board.new
        ship = double :ship, size: 5
        board.place(ship, 41, :north)
        expect(board.grid[1]).to eq ship
      end

      it 'raises an error when trying to place a ship out of bounds (northward)' do
        board = Board.new
        ship = double :ship, size: 5
        expect { board.place(ship, 31, :north) }.to raise_error "Ship cannot be placed here"
      end
    end

    context 'when all ships are sunk' do
      it 'registers that all ships are sunk' do
        ship = double :ship, size:5, sunk?: true
        subject.place(ship, 1, :east)
        expect(subject.all_sunk?).to eq(true)
      end
    end
    context 'when not all ships are sunk' do
      it 'registers that not all ships are sunk' do
        ship = Ship.new 1 #double :ship, size:5, sunk?: true
        ship2 = Ship.new 5 #double :ship, size:5, sunk?: false
        subject.place(ship, 1, :east)
        subject.hit(1)
        subject.place(ship2, 11, :east)
        expect(subject.all_sunk?).to eq(false)
      end
    end


  end
end
