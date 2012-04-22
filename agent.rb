class Agent
  include CP::Object

  attr_reader :shape

  WIDTH = 10.0
  HEIGHT = 30.0
  WALKING_FORCE = 400.0

  def initialize
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('agent.png'), true)
    @facing = 1
    @living = true
    body = CP::Body.new(10.0, CP.moment_for_box(10.0, WIDTH, HEIGHT))
    body.p = CP::Vec2.new(0.0, 0.0)
    body.v = CP::Vec2.new(0.0, 0.0)
    body.velocity_func do |body,g,damping,dt|
      body.update_velocity(g,damping,dt)
      body.v.x = CP.clamp(body.v.x, -20, 20)
      body.v.y = CP.clamp(body.v.y, -1000, 1000)
    end

    shape_array = [CP::Vec2.new(0.0 - WIDTH/2.0, 0.0 - HEIGHT/2), CP::Vec2.new(0.0 - WIDTH/2.0, HEIGHT/2), CP::Vec2.new(WIDTH/2.0, HEIGHT/2), CP::Vec2.new(WIDTH/2.0, 0.0 - HEIGHT/2)]
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :foe
    @shape.u = 0.30
    @shape.object = self

    GameWindow.window.space.add_body body
    GameWindow.window.space.add_shape @shape
  end

  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, 1, @shape.body.a.radians_to_degrees)
  end

  def shoot
    return if @last_shot && Time.now - @last_shot < 2
    b = Bullet.new(@facing)
    b.warp(@shape.body.p.x + 1.0 + @facing * (WIDTH/2), @shape.body.p.y - 8)
    @last_shot = Time.now
  end

  def warp(pos)
    @shape.body.p = pos
  end

  def go_right
    @facing = 1.0
    walk
  end

  def go_left
    @facing = -1.0
    walk
  end

  def walk
    @shape.body.apply_force(CP::Vec2.new(@facing * WALKING_FORCE, 0.0), CP::Vec2.new(0.0,0.0))
  end

  def jump
    return if @last_jump && Time.now - @last_jump < 0.5
    @shape.body.apply_force(CP::Vec2.new(0.0,-100000.0), CP::Vec2.new(0.0,0.0))
    @last_jump = Time.now
  end

  def kill
    @living = false
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('agent_dead.png'), true)
  end
end
