require_relative 'drawable'
class Triangle < Drawable
    attr_accessor :pos_2, :pos_3, :color, :angle
    def initialize root, pos_1, pos_2, pos_3, color: Gosu::Color::BLACK, angle: 0, &constraint
        super(root, &constraint)
        @pos_1, @pos_2, @pos_3, @color, @angle = pos_1, pos_2, pos_3, color, angle
        @rectangle.x, @rectangle.y = pos_1.x, pos_1.y
    end
    def draw
        Gosu.draw_triangle(@rectangle.x, @rectangle.y, @color, @pos_2.x, @pos_2.y, @color, @pos_3.x, @pos_3.y, @color)
    end
end