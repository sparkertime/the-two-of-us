require_relative 'utils'

class Player
  def initialize(window)
    @image = Gosu::Image.new(window, Utils.image_url('player.png'), false)
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  def warp(x,y)
    @x,@y = x,y
  end
end
