require_relative 'ui_elements/drawables/sprite'
require_relative 'ui_elements/ui_element'
require_relative 'tools/vector'
class Robert < UIElement
    attr :position, :direction, :tileset, :tileset_height, :tileset_width, :tile
    TILE_HEIGHT = 256
    TILE_WIDTH = 256
    TILE_BY_LINE = 4
    TILE_BY_COLUMN = 4
    DIRECTIONS_TILES = {
        tile_up: 12,
        tile_right: 9,
        tile_down: 0,
        tile_left: 4
    }
    def initialize x=0, y=0
        @start_pos = @position = Vector2.new(x,y)
        @tileset = Gosu::Image.load_tiles(__dir__+'/assets/robert.png', TILE_HEIGHT/TILE_BY_COLUMN, TILE_WIDTH/TILE_BY_LINE)
        reset
    end
    def reset
        @current_animation = nil
        @direction = :right
        set_pos(@start_pos.x, @start_pos.y)
        @tile = :tile_right
    end
    def set_pos x, y
        @position.x = x
        @position.y = y
    end
    def set_origin x, y
        @start_pos.x = x
        @start_pos.y = y
        set_pos(x, y)
    end
    def draw posX, posY
        @tileset[DIRECTIONS_TILES[@tile]].draw(posX, posY, 0)
    end
    def move_to x, y, &complete_handler
        p "robert move to #{x}, #{y}"
        initial_pos = @position
        target_pos = Vector2.new x, y
        animate(0.5, on_progression: ->(linear_progress)do
            ease_progress = smooth_progression linear_progress
            @position = initial_pos + (target_pos - initial_pos)*ease_progress
        end, on_finish: complete_handler)
    end
    def animate duration, time = Time.now.to_f, on_progression: nil, on_finish: nil
        @current_animation = {
            start_stamp: time,
            duration: duration,
            handler: on_progression,
            completion_handler: on_finish
        }
    end
    def update
        time = Time.now.to_f
        if @current_animation
            progression = ((time - @current_animation[:start_stamp]) / @current_animation[:duration]).clamp(0,1)
            @current_animation[:handler].call progression
            if progression == 1
                @current_animation[:completion_handler].call if @current_animation[:completion_handler]
                @current_animation = nil
            end
        end
    end
    def smooth_progression progression, timing_function= :ease
        return progression * progression * (3 - 2 * progression) if timing_function == :ease
        progression
    end
    # exec method
    def move_forward &complete_handler
        to_pos = @position.clone
        case @direction
        when :up then to_pos.y -= 1
        when :right then to_pos.x += 1
        when :down then to_pos.y += 1
        when :left then to_pos.x -= 1
        end
        move_to(to_pos.x, to_pos.y, &complete_handler)
    end
    def turn_left
        sleep 0.25
        case @direction
        when :up then 
            @direction = :left
            @tile = :tile_left
        when :right then 
            @direction = :up
            @tile = :tile_up
        when :down then 
            @direction = :right
            @tile = :tile_right
        when :left then 
            @direction = :down
            @tile = :tile_down
        end
        sleep 0.25
    end
    def turn_right
        sleep 0.25
        case @direction
        when :up then 
            @direction = :right
            @tile = :tile_right
        when :right then 
            @direction = :down
            @tile = :tile_down
        when :down then 
            @direction = :left
            @tile = :tile_left
        when :left then 
            @direction = :up
            @tile = :tile_up
        end
        sleep 0.25
    end
end