class Vector2
    attr_accessor :x, :y
    def initialize x= 0, y= 0
        @x, @y = x, y
    end
    def * value
        self.class.new @x * value, @y * value
    end
    def / value
        self.* 1/value
    end
    def + value
        self.class.new @x + value, @y + value
    end
    def - value
        self.+ -value
    end
    def multiply! value
        @x *= value
        @y *= value
        self
    end
    def add! value
        @x += value
        @y += value
        self
    end
end