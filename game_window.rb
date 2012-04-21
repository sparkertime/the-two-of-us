require 'chipmunk'
require_relative 'player'
require_relative 'floor'

class GameWindow < Gosu::Window
  def self.window
    @@window ||= GameWindow.new
  end

  def self.start
    window.load_objects
    window.show
  end

  def initialize
    super 1024, 768, false
    self.caption = "The Two of Us"

    space.damping = 0.8
    space.gravity = CP::Vec2.new(0.0, 80.0)
  end

  def space
    @space ||= CP::Space.new
  end

  def load_objects
    @bg = Gosu::Image.new(self, Utils.image_url("background.png"), true)

    @player = Player.new
    @player.warp 400,400
    @floor = Floor.new
    @floor.warp 400, 683
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @player.shoot if (id == Gosu::KbZ) || (id == Gosu::KbSpace)
  end

  def draw
    @bg.draw(0,0,0)
    @player.draw
  end

  def update
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
