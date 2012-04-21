require_relative 'utils'

class Player
  include CP::Object

  WIDTH = 13.0
  HEIGHT = 30.0
  WALKING_VELOCITY = 1000.0

  def initialize
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('player.png'), false)
    @facing = 1
    body = CP::Body.new(10.0, CP::INFINITY)
    body.p = CP::Vec2.new(0.0, 0.0)
    body.v = CP::Vec2.new(0.0, 0.0)
    body.velocity_func do |body,g,damping,dt|
      body.update_velocity(g,damping,dt)
      body.v.x = CP.clamp(body.v.x, -50, 50)
      body.v.y = CP.clamp(body.v.y, -1000, 1000)
    end

    shape_array = [CP::Vec2.new(0.0 - WIDTH/2.0, 0.0 - HEIGHT/2), CP::Vec2.new(0.0 - WIDTH/2.0, HEIGHT/2), CP::Vec2.new(WIDTH/2.0, HEIGHT/2), CP::Vec2.new(WIDTH/2.0, 0.0 - HEIGHT/2)]
    @shape = CP::Shape::Poly.new(body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :player
    @shape.u = 0.30

    GameWindow.window.space.add_body body
    GameWindow.window.space.add_shape @shape
  end

  def draw
    @image.draw(@shape.body.p.x, @shape.body.p.y, 1)
  end

  def shoot
    #return if @last_shot && Time.now - @last_shot < 0.3
    #b = Bullet.new(@facing)
    #b.warp(@shape.body.p.x + (@facing * 
  end

  def warp(x,y)
    @shape.body.p = CP::Vec2.new(x,y)
  end

  def shape
    @shape
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
    @shape.body.apply_force(CP::Vec2.new(@facing * WALKING_VELOCITY, 0.0), CP::Vec2.new(0.0,0.0))
  end

  def jump
    @facing = 1
    return if @last_jump && Time.now - @last_jump < 0.5
    @shape.body.apply_force(CP::Vec2.new(0.0,-100000.0), CP::Vec2.new(0.0,0.0))
    @last_jump = Time.now
  end
end
