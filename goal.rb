require_relative 'utils'

class Goal
  include CP::Object

  attr_accessor :shape

  WIDTH = 40.0
  HEIGHT = 40.0

  def initialize
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('goal.png'), true)

    body = CP::StaticBody.new
    body.p = CP::Vec2.new(0.0, 0.0)

    shape_array = [CP::Vec2.new(0.0 - WIDTH/2.0, 0.0 - HEIGHT/2), CP::Vec2.new(0.0 - WIDTH/2.0, HEIGHT/2), CP::Vec2.new(WIDTH/2.0, HEIGHT/2), CP::Vec2.new(WIDTH/2.0, 0.0 - HEIGHT/2)]
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :goal
    @shape.u = 0.4

    GameWindow.window.space.add_static_shape @shape
  end

  def draw
    @image.draw(@shape.body.p.x - WIDTH / 2.0, @shape.body.p.y - HEIGHT / 2.0, 1)
  end

  def warp(pos)
    @shape.body.p = pos
    GameWindow.window.space.rehash_shape(@shape)
  end

  def update
    @shape.body.reset_forces
  end
end
