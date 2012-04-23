require_relative 'utils'
require_relative 'bullet'

class Player
  include CP::Object
  
  attr_reader :shape

  WIDTH = 13.0
  HEIGHT = 30.0
  WALKING_FORCE = 1000.0

  def initialize
    @image = Gosu::Image.new(GameWindow.window, Utils.image_url('player.png'), false)
    @facing = 1
    @jump_ticks = 1000
    @shoot_ticks = 1000
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
    @shape.object = self

    GameWindow.window.space.add_body body
    GameWindow.window.space.add_shape @shape
  end

  def draw
    @image.draw(@shape.body.p.x - WIDTH / 2.0, @shape.body.p.y - HEIGHT / 2.0, 1)
  end

  def shoot
    return if @shoot_ticks < 100
    b = Bullet.new(self, @facing)
    b.warp CP::Vec2.new(@shape.body.p.x + @facing * ( 2.0 + WIDTH/2), @shape.body.p.y - 6)
    @shoot_ticks = 0
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
    return if @jump_ticks < 200
    @shape.body.apply_force(CP::Vec2.new(0.0,-100000.0), CP::Vec2.new(0.0,0.0))
    @jump_ticks = 0
  end

  def kill(reason)
    puts "#####################################"
    puts " YOU HAVE PERISHED (cause: #{reason})"
    puts "#####################################"
    exit
  end

  def win(reason)
    puts "#######################################"
    puts " YOU HAVE VICTORIED! (cause: #{reason})"
    puts "#######################################"
    exit
  end

  def update
    @jump_ticks += 1
    @shoot_ticks += 1
    @shape.body.reset_forces
  end
end
