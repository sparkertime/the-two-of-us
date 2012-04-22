class Bullet
  include CP::Object

  attr_accessor :shooter

  WIDTH = 9.0
  HEIGHT = 3.0
  VELOCITY = 300.0

  def initialize(shooter, direction)
    @created_at = Time.now
    @shooter = shooter

    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('bullet.png'), false)
    body = CP::Body.new(0.5, CP.moment_for_box(0.5, WIDTH, HEIGHT))
    body.p = CP::Vec2.new(0.0, 0.0)
    body.v = CP::Vec2.new(direction * VELOCITY, 0.0)
    body.velocity_func do |body, gravity, damping, dt|
      body.v.y = 0 #bullets only travel horizontally
      body.v.x = direction * VELOCITY #bullets only travel horizontally
    end

    @shape = CP::Shape::Segment.new(body, CP::Vec2.new(0.0 - WIDTH / 2.0, 0.0), CP::Vec2.new(0.0 + WIDTH / 2.0, 0.0), 1)
    @shape.collision_type = :bullet
    @shape.object = self

    GameWindow.window.space.add_body body
    GameWindow.window.space.add_shape @shape
    GameWindow.window.add_bullet self
  end

  # ewww, side effect-tastic. basically a violation of everything I hold dear.
  def deletable?
    return unless Time.now - @created_at > 2
    GameWindow.window.space.remove_body @shape.body
    GameWindow.window.space.remove_shape @shape
    true
  end

  def draw
    @image.draw(@shape.body.p.x - WIDTH / 2.0, @shape.body.p.y - HEIGHT / 2.0, 1)
  end

  def warp(pos)
    @shape.body.p = pos
  end
end
