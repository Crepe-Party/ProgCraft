require_relative '../../core/tools/vector'
class Robert
    attr_accessor :rectangle, :direction
    DIRECTION_FONT = Gosu::Font.new(100)
    DIRECTIONS_ANGLES = {
        up: 0,
        right: 90,
        down: 180,
        left: 270
    }
    def initialize x=0, y=0
        @start_pos = Vector2.new x, y
        reset
    end
    def reset
        @angle_offset = 0
        @current_animation = nil
        @rectangle = Rectangle2.new(@start_pos.x, @start_pos.y, TILE_SIZE, TILE_SIZE)
        @direction = :right
    end
    def move_to x, y, &complete_handler
        p "robert move to #{x}, #{y}"
        initial_pos = @rectangle.position
        target_pos = Vector2.new x, y
        animate(1.0, on_progression: ->(linear_progress)do
            ease_progress = smooth_progression linear_progress
            @rectangle.position = initial_pos + (target_pos - initial_pos)*ease_progress
        end, on_finish: complete_handler)
    end
    def rotate_to new_direction, clockwise: true, &completion_handler
        p "robert rotate to #{new_direction}"
        angle_diff = DIRECTIONS_ANGLES[new_direction] - DIRECTIONS_ANGLES[@direction]
        angle_diff += 360 if DIRECTIONS_ANGLES[new_direction] < DIRECTIONS_ANGLES[@direction] && clockwise #prevent broken rotation
        angle_diff -= 360 if DIRECTIONS_ANGLES[new_direction] > DIRECTIONS_ANGLES[@direction] && !clockwise #prevent broken rotation
        animate(1.0, 
            on_progression: ->(linear_progress) do
                @angle_offset = angle_diff * smooth_progression(linear_progress)
            end, on_finish: ->() do 
                @direction = new_direction
                @angle_offset = 0
                completion_handler.call if completion_handler
            end
        )
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
    def draw top
        # p DIRECTIONS_ANGLES, @direction, @angle_offset
        angle = DIRECTIONS_ANGLES[@direction] + @angle_offset
        x, y = @rectangle.x * TILE_SIZE, @rectangle.y * TILE_SIZE + top
        center_point = Rectangle2.new(x, y, @rectangle.width, @rectangle.height).center
        # p center_point, x, y
        Gosu.rotate angle, center_point.x, center_point.y do
            Gosu.draw_rect x, y, @rectangle.width, @rectangle.height, Gosu::Color::WHITE
            draw_centered_text(DIRECTION_FONT, "▲", x, y, @rectangle.width, @rectangle.height, Gosu::Color::BLACK)
        end
    end
    def animate duration, time = Time.now.to_f, on_progression: nil, on_finish: nil
        @current_animation = {
            start_stamp: time,
            duration: duration,
            handler: on_progression,
            completion_handler: on_finish
        }
    end
    def smooth_progression progression, timing_function= :ease
        return progression * progression * (3 - 2 * progression) if timing_function == :ease
        progression
    end
end