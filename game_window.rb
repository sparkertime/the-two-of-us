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

    @bg = Gosu::Image.new(self, Utils.image_url("background.png"), true)
  end

  def load_objects
    @player = Player.new(self)
    @player.warp 400,400
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def draw
    @bg.draw(0,0,0)
    @player.draw
  end
end
