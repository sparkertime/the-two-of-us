require 'chipmunk'
require_relative 'player'
require_relative 'agent'
require_relative 'floor'
require_relative 'tile'
require_relative 'goal'
require_relative 'map'

class GameWindow < Gosu::Window
  def self.start
    window.load_objects
    window.show
  end

  def self.window
    @@window ||= GameWindow.new
  end

  def add_bullet(b)
    @bullets << b
  end

  def initialize
    super Map::WIDTH.round, Map::HEIGHT.round, false
    self.caption = "The Two of Us"

    @bullets = []
    @translate_x = 0
    space.damping = 0.8
    space.gravity = CP::Vec2.new(0.0, 80.0)
  end

  def space
    return @space if @space
    @space = CP::Space.new
    @space.add_collision_func(:foe, :bullet) do |foe, _|
      foe.object.kill
      true
    end
    @space.add_collision_func(:player, :bullet) do |player, bullet|
      player.object.kill('bullet') unless bullet.object.shooter == player.object
      true
    end
    @space.add_collision_func(:player, :foe) do |player, foe|
      player.object.kill('touching') if foe.object.living?
      true
    end
    @space.add_collision_func(:player, :goal) do |player, goal|
      player.object.win('winning')
      true
    end
    @space
  end

  def load_objects
    @bg = Gosu::Image.new(self, Utils.image_url("background.png"), true)

    @floor = Floor.new
    @floor.warp CP::Vec2.new(400, 700)
    @map = Map.from_file Utils.image_url('map.txt')
    @player = @map.objects.reject {|o| o.class != Player }.first
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @player.shoot if (id == Gosu::KbZ) || (id == Gosu::KbSpace)
  end

  def draw
    translate(@translate_x, 0) do
      @bg.draw(0,0,0)
      @bg.draw(1024,0,0)
      @bg.draw(2048,0,0)
      @map.objects.each {|o| o.draw }
      @bullets.each {|b| b.draw }
    end
  end

  def update
    @bullets.delete_if { |b| b.deletable? }
    @translate_x -= 2.0

    6.times do
      @map.objects.each {|o| o.update }
      if button_down? Gosu::KbRight
        @player.go_right
      end
      if button_down? Gosu::KbLeft
        @player.go_left
      end
      if button_down? Gosu::KbUp
        @player.jump
      end
      @space.step(1.0 / 60.0)
    end
  end
end
