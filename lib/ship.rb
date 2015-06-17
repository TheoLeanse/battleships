class Ship
  attr_reader :size
  def initialize(size = 1)
    @size = size
    @hit = false
    @life = size
  end

  def hit
    @hit = true
    @life -= 1
  end

  def hit?
    @hit
  end

  def sunk?
    @life == 0
  end
end
