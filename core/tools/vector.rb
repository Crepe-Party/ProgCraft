class Vector2
    include Comparable
    attr_accessor :x, :y
    def initialize x= 0, y= 0
        @x, @y = x, y
    end
    def * scl_or_vector
        self.clone.scl! scl_or_vector
    end
    def scl! x_scl_or_vector, y_scl = nil
        x_scl_or_vector, y_scl = x_scl_or_vector.x, x_scl_or_vector.y if x_scl_or_vector.instance_of? Vector2
        y_scl=x_scl_or_vector unless y_scl

        @x *= x_scl_or_vector
        @y *= y_scl
        self
    end
    def scl x_scl_or_vector, y_scl = nil
        self.clone.scl! x_scl_or_vector, y_scl
    end
    def / scl_or_vect
        return self * (1/scl_or_vect) unless scl_or_vect.instance_of? Vector2
        self.scl(1.0/scl_or_vect.x, 1.0/scl_or_vect.y)
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
    def floor
        self.clone.floor!
    end
    def floor!
        @x, @y = @x.floor, @y.floor
        self
    end
    def assign! vector=nil, x:nil, y:nil
        x,y= rectangle.to_a if vector
        @x = x if x
        @y = y if y
        self
    end
    def length
        Math.sqrt(@x**2 + @y**2)
    end
    def inside? rectangle
        rectangle.includes? self
    end
    def <=>(vector)
        return nil unless vector.instance_of?(Vector2)
        return 0 if @x == vector.x and @y == vector.y
        self.length <=> vector.length
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
    def relative_to **args
        self.clone.relative_to! **args
    end
    def relative_to! rectangle=nil, x:nil, y:nil, width:nil, height:nil
        x,y,width,height = rectangle.to_a if rectangle
        self.x += x if x
        self.y += y if y
        self.width += width if width
        self.height += height if height
        self
    end
    def intersects? rectangle
        return !(self.x > rectangle.right || self.y > rectangle.bottom || self.right < rectangle.x || self.bottom < rectangle.y)
    end
    def assign! rectangle=nil, x:nil, y:nil, width:nil, height:nil
        x,y,width,height = rectangle.to_a if rectangle
        @x = x if x
        @y = y if y
        @width = width if width
        @height = height if height
        self
    end
    def assign rectangle=nil, x:nil, y:nil, width:nil, height:nil
        self.clone.assign!(rectangle, x:x, y:y, width:width, height:height)
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