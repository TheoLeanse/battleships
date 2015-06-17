require 'player'

describe Player do

  it { is_expected.to respond_to(:board) }

  describe '#board' do
    it 'should be able to return a grid' do
      expect(subject.board.row_size).to eq(10)
    end 
  end

end
