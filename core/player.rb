require_relative 'ui_elements/drawables/sprite'
require_relative 'ui_elements/ui_element'
require_relative 'tools/vector'
class Player < UIElement
    attr :position, :texture, :direction
    def initialize x=0, y=0
        @position = Vector2.new(x,y)
        @texture = Gosu::Image.new(__dir__+'/assets/robert_test.png')
        @direction = 'est'
    end
    def set_pos x, y
        @position.x = x
        @position.y = y
    end
    def draw posX, posY
        @texture.draw(posX, posY, 0)
    end
    
end