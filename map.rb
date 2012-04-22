class Map
  HEIGHT = 768.0
  WIDTH = 1024.0
  BLOCK_SIZE = 40.0

  attr_accessor :objects

  def self.from_file(file)
    lines = File.readlines(file).map {|line| line.chomp }
    Map.new(lines)
  end

  def initialize(lines)
    @lines = lines
    @block_height = HEIGHT / lines.size
    @block_width = WIDTH / lines[0].size
    @objects = []
    load_map
  end

  def load_map
    @lines.each_with_index do |line, y|
      x = 0
      line.each_char do |tile|
        case tile
        when 'p'
          obj = Player.new
        when 'e'
          obj = Agent.new
        when '#'
          obj = Tile.new
        end
        if obj
          obj.warp block_to_world_coord(x,y)
          @objects << obj
        end
        x += 1
      end
    end
  end

  def block_to_world_coord(x,y)
    CP::Vec2.new(BLOCK_SIZE * x, BLOCK_SIZE * y)
  end
end
