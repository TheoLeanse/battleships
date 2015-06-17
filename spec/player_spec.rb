require 'player'

describe Player do
  let(:board) { double :board, place: nil }
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

  xit 'can receive a hit from opponent and send it to its board' do

  end

  xit 'can only send message to board on a players turn' do

  end

  xit 'is told when all its ships are sunk' do

  end

end
