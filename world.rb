module World
  class << self
    def load(window)
      @window = window
    end

    def window
      @window
    end
  end
end
