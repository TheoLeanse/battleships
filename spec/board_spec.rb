require 'board'

describe Board do

  it "has a set of grid" do
    expect(subject).to respond_to(:grid)
  end

  it "recalls whether a spot is occupied" do
    expect(subject.grid[1]).to eq('unoccupied')
  end

  it "responds to #place with three arguments" do
    expect(subject).to respond_to(:place).with(3).arguments
  end

  it "responds to #cell_occupied?" do
    expect(subject).to respond_to(:cell_occupied?)
  end

  it "checks that a given location is on the board" do
    expect(subject.grid.keys).to include 1
  end

  it 'responds to create' do
    expect(subject).to respond_to(:create_grid).with(1).argument
  end

  it 'responds to misses' do
    expect(subject).to respond_to(:misses)
  end

  it 'responds to hits' do
    expect(subject).to respond_to(:hits)
  end

  describe 'hit' do

    it 'responds to hit' do
      expect(subject).to respond_to(:hit).with(1).argument
    end


    it 'changes a ship status' do
      ship = double :ship , size: 1
      board = Board.new
      board.place(ship,1,:east)

      expect(ship).to receive :hit
      board.hit(1)
    end

    it 'stores an array of hits' do
      ship = double :ship , size: 1, hit: true
      board = Board.new
      board.place(ship,1,:east)

      board.hit(1)
      expect(board.hits).to eq [1]

    end

    it 'stores an array of misses' do
      subject.hit(1)
      expect(subject.misses).to eq [1]
    end

    it 'throws an error if the guess is a repeat' do

      subject.hit(1)
      expect { subject.hit(1) }.to raise_error "Invalid guess (cell has already been hit)"

    end
  end


  describe 'create' do

    it 'creates a hash' do
      hash = {1 => 'unoccupied', 2 => 'unoccupied', 3 => 'unoccupied', 4 => 'unoccupied'}
      expect(subject.create_grid(2)).to eq hash
    end

  end

  describe "cell_occupied?" do

    it "responds true when space is occupied" do
      ship = double :ship, size: 1
      subject.place(ship, 1, :east)
      expect(subject.cell_occupied? 1).to eq(true)
    end

    it "responds false when space is unoccupied" do
      expect(subject.cell_occupied? 1).to eq(false)
    end

  end


  describe "#place" do



    it "raises an error when placing a ship in an occupied space" do
      ship = double :ship, size: 1
      subject.place(ship, 1, :east)
      expect { subject.place(:ship, 1, :east) }.to raise_error 'Space is occupied'
    end

    it "raises an error when placing a ship in a space that doesn't exist" do
      expect { subject.place(:ship, subject.grid.length + 1, :east) }.to raise_error 'Cannot place ships off the board'
    end

    # it "raises an error if there are not enough grid available for the whole ship" do
    #   bigship = double :bigship, size: subject.grid.count + 1
    #   expect { subject.place(bigship, 1, :west) }.to raise_error "Ship cannot be placed here"
    # end

    context 'when given a ship of big size' do

      it 'places the same ship over multiple cells (east)' do
        board = Board.new
        ship = double :ship, size: 2
        board.place(ship, 1, :east)
        expect(board.grid[2]).to eq ship
      end

      it 'places the same ship over multiple cells (west)' do
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

    end
  end
end
