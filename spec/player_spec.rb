require 'player'

describe Player do
  let(:board) { double :board, place: nil, all_sunk?: true }
  subject { Player.new board }
  let(:ship) { double :ship }

  it 'has an opponent' do
    expect(subject).to respond_to(:opponent)
  end

  it 'can instruct ships to be placed on the board' do
    expect(board).to receive(:place)
    subject.place_ship(ship, 1, :east)
  end

  it 'can instruct cells to be fired on opponent board' do
    opponent = double :opponent, hit: nil
    subject.opponent = opponent
    expect(opponent).to receive(:hit)
    subject.fire(2)
  end

  it 'can tell the board it has been hit' do
    expect(board).to receive(:hit)
    subject.hit(1)
  end

  it 'is told when all its ships are sunk' do
    expect(board).to receive :all_sunk?
    subject.all_sunk?
  end

  xit 'can only send message to board on a players turn' do

  end

  xit "only allows a player to place the correct number and sizes of ship" do
    # Good implementation?
  end
end
