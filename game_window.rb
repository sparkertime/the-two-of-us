require 'chipmunk'
require_relative 'player'
require_relative 'agent'
require_relative 'floor'
require_relative 'tile'
require_relative 'map'

class GameWindow < Gosu::Window
  def self.window
    @@window ||= GameWindow.new
  end

  def add_bullet(b)
    @bullets << b
  end

  def self.start
    window.load_objects
    window.show
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
    @space ||= CP::Space.new
  end

  def load_objects
    @bg = Gosu::Image.new(self, Utils.image_url("background.png"), true)

    #@player = Player.new
    #@player.warp 400,670
    #@agent = Agent.new
    #@agent.warp 800,670
    @floor = Floor.new
    @floor.warp CP::Vec2.new(400, 700)
    @map = Map.from_file 'map.txt'
    @player = @map.objects.reject {|o| o.class != Player }.first
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @player.shoot if (id == Gosu::KbZ) || (id == Gosu::KbSpace)
  end

  def draw
    translate(@translate_x, 0) do
      @bg.draw(0,0,0)
      #@player.draw
      #@agent.draw
      @map.objects.each {|o| o.draw }
      @bullets.each {|b| b.draw }
    end
  end

  def update
    @bullets.delete_if { |b| b.deletable? }
    #@translate_x -= 1

    6.times do
      @player.shape.body.reset_forces
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
