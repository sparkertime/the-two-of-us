require 'chipmunk'
require_relative 'player'

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
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def draw
    @bg.draw(0,0,0)
    @player.draw
  end

  def update
    6.times do
      @space.step(1.0 / 60.0)
    end
  end
end
