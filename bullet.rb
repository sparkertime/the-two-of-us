class Bullet
  include CP::Object

  WIDTH = 3.0
  HEIGHT = 1.0
  VELOCITY = 300.0

  def initialize(direction)
    @created_at = Time.now

    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('bullet.png'), false)
    body = CP::Body.new(0.5, CP.moment_for_box(0.5, WIDTH, HEIGHT))
    body.p = CP::Vec2.new(0.0, 0.0)
    body.v = CP::Vec2.new(VELOCITY, 0.0)
    body.velocity_func do |body, gravity, damping, dt|
      body.v.y = 0 #bullets only travel horizontally
      body.v.x = VELOCITY #bullets only travel horizontally
    end

    @shape = CP::Shape::Segment.new(body, CP::Vec2.new(0.0 - WIDTH / 2.0, 0.0), CP::Vec2.new(0.0 + WIDTH / 2.0, 0.0), 1)
    @shape.collision_type = :bullet

    GameWindow.window.space.add_body body
    GameWindow.window.space.add_shape @shape
    GameWindow.window.add_bullet self
  end

  def deletable?
    Time.now - @created_at > 2
  end

  def draw
    @image.draw(@shape.body.p.x, @shape.body.p.y, 1)
  end

  def warp(x,y)
    @shape.body.p = CP::Vec2.new(x,y)
  end
end
