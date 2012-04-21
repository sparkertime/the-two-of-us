require_relative 'utils'

class Tile
  include CP::Object

  def initialize
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('tile.png'), false)
    body = CP::StaticBody.new
    body.p = CP::Vec2.new(0.0, 0.0)

    shape_array = [CP::Vec2.new(-700.5, -7.5), CP::Vec2.new(-700.5, 7.5), CP::Vec2.new(700.5, 7.5), CP::Vec2.new(700.5, -7.5)]
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :tile
    @shape.u = 1.0

    GameWindow.window.space.add_static_shape @shape
  end

  def draw
    @image.draw(@shape.body.p.x, @shape.body.p.y, 1)
  end

  def warp(x,y)
    @shape.body.p = CP::Vec2.new(x,y)
    GameWindow.window.space.rehash_static
  end
end
