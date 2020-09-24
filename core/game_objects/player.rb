require_relative '../ui_elements/drawables/sprite'
require_relative '../ui_elements/ui_element'
require_relative '../tools/vector'
class Player < UIElement
    attr :position, :texture
    def initialize x=-100, y=-100
        @position = Vector2.new(x,y)
        @texture = Gosu::Image.new(__dir__+'/../assets/robert_test.png')
    end
    def set_pos x, y
        @position.x = x
        @position.y = y
    end
    def draw
        @texture.draw(@position.x, @position.y, 0)
    end
end