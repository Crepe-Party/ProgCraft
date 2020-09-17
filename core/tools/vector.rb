class Vector2
    attr_accessor :x, :y
    def initialize x= 0, y= 0
        @x, @y = x, y
    end
    def * scl
        self.clone.scale scl
    end
    def scale x_scl, y_scl = nil
        y_scl=x_scl unless y_scl
        @x *= x_scl
        @y *= y_scl
        self
    end
end

class Rectangle2
    attr_accessor :x, :y, :width, :height
    def initialize x=0, y=0, width=0, height=0
      @x, @y, @width, @height = x, y ,width, height
    end
end