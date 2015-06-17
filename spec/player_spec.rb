require 'player'

describe Player do
  subject { Player.new double :board, place_ship: nil }
  let(:ship) { double :ship }
  let(:board) { double :board }
  it 'can instruct ships to be placed on the board' do
    expect(board).to receive(:place_ship)
    subject.place_ship(ship, 1, :east)
  end

  xit 'can instruct cells to be fired on' do

  end

  xit 'can only send message to board on a players turn' do

  end

  xit 'is told when all its ships are sunk' do

  end

end
