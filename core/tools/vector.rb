class Vector2
    attr_accessor :x, :y
    def initialize x= 0, y= 0
        @x, @y = x, y
    end
    def * x_scl_or_vector, y_scl = nil
        self.clone.scl! x_scl_or_vector, y_scl
    end
    def scl! x_scl_or_vector, y_scl = nil
        x_scl_or_vector, y_scl = x_scl_or_vector.x, x_scl_or_vector.y if x_scl_or_vector.instance_of? Vector2
        y_scl=x_scl_or_vector unless y_scl

        @x *= x_scl_or_vector
        @y *= y_scl
        self
    end
    def / scl
        self * (1/scl)
    end
    def + vector
        self.clone.add! vector
    end
    def add! x_add_or_vector, y_add = nil
        x_add_or_vector, y_add = x_add_or_vector.x, x_add_or_vector.y if x_add_or_vector.instance_of? Vector2
        y_add=x_add_or_vector unless y_add

        @x += x_add_or_vector
        @y += y_add
        self
    end
    def - vector
        self + vector * -1
    end
    def inside? rectangle
        rectangle.includes? self
    end
    def to_a
        [@x, @y]
    end
end

class Rectangle2
    attr_accessor :x, :y, :width, :height
    def initialize x=0, y=0, width=0, height=0
      @x, @y, @width, @height = x, y ,width, height
    end
    def position
        Vector2.new @x, @y
    end
    def position= vector
        @x, @y = vector.x, vector.y
    end
    def size
        Vector2.new @width, @height
    end
    def size= vector
        @width, @height = vector.x, vector.y
    end
    def right
        @x + @width
    end
    def bottom
        @y + @height
    end
    def center
        self.position + (self.size / 2.0)
    end
    def relative_to rel_x_or_rect=0,rel_y=0,rel_width=0,rel_height=0, rel_dimensions: false
        rel_x_or_rect, rel_y, rel_width, rel_height = rel_x_or_rect.x, rel_x_or_rect.y, rel_x_or_rect.width, rel_x_or_rect.height if rel_x_or_rect.instance_of? Rectangle2
        return Rectangle2.new(@x + rel_x_or_rect, @y + rel_y, rel_width, rel_height) unless rel_dimensions
        Rectangle2.new(@x + rel_x_or_rect, @y + rel_y, @width + rel_width, @height + rel_height)
    end
    def intersects? rectangle
        return !(self.x > rectangle.right || self.y > rectangle.bottom || self.right < rectangle.x || self.bottom < rectangle.y)
    end
    def assign rectangle
        @x = rectangle.x || @x
        @y = rectangle.y || @y
        @width = rectangle.width || @width
        @height = rectangle.height || @height
    end
    def intersection rectangle
        return nil unless self.intersects? rectangle #no intersection
        int_x = [self.x, rectangle.x].max
        int_y = [self.y, rectangle.y].max
        int_right = [self.right, rectangle.right].min
        int_bottom = [self.bottom, rectangle.bottom].min
        Rectangle2.new(int_x, int_y, int_right - int_x, int_bottom - int_y)
    end  
    def includes? pos_x_or_vector, pos_y
        pos_x_or_vector, pos_y = pos_x_or_vector.x, pos_x_or_vector.y if pos_x_or_vector.instance_of? Vector2
        pos_x_or_vector.between?(x, right) && pos_y.between?(y, bottom)
    end
    def to_a
        [@x, @y, @width, @height]
    end
end