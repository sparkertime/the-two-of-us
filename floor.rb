require_relative 'utils'

class Floor
  include CP::Object

  def initialize
    body = CP::StaticBody.new
    body.p = CP::Vec2.new(0.0, 0.0)

    @shape = CP::Shape::Segment.new(body, CP::Vec2.new(-10000.0, 0.0), CP::Vec2.new(10000.0, 0.0), 2)
    @shape.collision_type = :floor
    @shape.u = 1.0

    GameWindow.window.space.add_static_shape @shape
  end

  def shape
    @shape
  end

  def warp(x,y)
    @shape.body.p = CP::Vec2.new(x,y)
    GameWindow.window.space.rehash_static
  end
end
