require_relative 'utils'

class Floor
  include CP::Object

  def initialize
    body = CP::StaticBody.new
    body.p = CP::Vec2.new(0.0, 0.0)

    shape_array = [CP::Vec2.new(-10000.0, -1), CP::Vec2.new(-10000.0, 1), CP::Vec2.new(10000.0, 1), CP::Vec2.new(10000.0, -1)]
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :floor
    @shape.u = 1.0

    GameWindow.window.space.add_static_shape @shape
  end

  def warp(x,y)
    @shape.body.p = CP::Vec2.new(x,y)
    GameWindow.window.space.rehash_static
  end
end
