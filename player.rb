require_relative 'utils'

class Player
  def initialize
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('player.png'), false)
    body = CP::Body.new(10.0, 150.0)
    body.p = CP::Vec2.new(0.0, 0.0)
    body.v = CP::Vec2.new(0.0, 0.0)

    shape_array = [CP::Vec2.new(-7.0, -25.0), CP::Vec2.new(-7.0, 25.0), CP::Vec2.new(7.0, 25.0), CP::Vec2.new(7.0, -25.0)]
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :player

    GameWindow.window.space.add_body body
    GameWindow.window.space.add_shape @shape
  end

  def draw
    @image.draw(@shape.body.p.x, @shape.body.p.y, 1)
  end

  def warp(x,y)
    @shape.body.p = CP::Vec2.new(x,y)
  end
end
