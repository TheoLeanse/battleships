require 'ship'

describe Ship do
  it { is_expected.to respond_to :size }
  it { is_expected.to respond_to :sunk?}

  it 'responds to #hit' do
    expect(subject).to respond_to :hit
  end

  describe "size" do
    it "returns the size of the ship" do
      ship = Ship.new(5)
      expect(ship.size).to eq(5)
    end
  end

  describe 'hit' do
    it 'registers a strike' do
      subject.hit
      expect(subject).to be_hit
    end
  end

  describe 'sunk' do
    it 'can get sunk' do
      ship = Ship.new(3)
      3.times { ship.hit }
      expect(ship).to be_sunk
    end
  end
end
