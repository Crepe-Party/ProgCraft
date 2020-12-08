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
    # exec method
    def move_forward
        case @direction
        when 'north' then @player.position.y -= 1
        when 'est' then @player.position.x += 1
        when 'south' then @player.position.y += 1
        when 'west' then @player.position.x -= 1
        end
    end
    def turn_left
        case @player.direction
        when 'north' then @player.direction = 'west'
        when 'est' then @player.direction = 'north'
        when 'south' then @player.direction = 'est'
        when 'west' then @player.direction = 'south'
        end
    end
    def turn_right
        case @player.direction
        when 'north' then @player.direction = 'est'
        when 'est' then @player.direction = 'south'
        when 'south' then @player.direction = 'west'
        when 'west' then @player.direction = 'north'
        end
    end
end