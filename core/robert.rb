require_relative 'ui_elements/drawables/sprite'
require_relative 'ui_elements/ui_element'
require_relative 'tools/vector'
require_relative 'config'
class Robert
    attr :position, :direction, :tileset, :tileset_height, :tileset_width, :tile
    TILE_HEIGHT = 256
    TILE_WIDTH = 256
    TILE_BY_LINE = 4
    TILE_BY_COLUMN = 4  
    STUN_TIME = 1 # seconds
    
    DIRECTIONS_TILES = {
        down:0,
        left:4,
        right:8,
        up:12,
    }

    def initialize root, x=0, y=0
        @root = root
        @start_pos = @position = Vector2.new(x,y)
        @tileset = Gosu::Image.load_tiles(File.join(Config::ASSETS_DIR, 'robert.png'), 64, 64)
        @stun = Gosu::Image.load_tiles(File.join(Config::ASSETS_DIR, 'robert_stun.png'), 64, 64)        
        reset
    end
    def reset
        @current_animation = nil
        @state = :idle
        @direction = :right
        set_pos(@start_pos.x, @start_pos.y)
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
    def update
    end
    def draw posX, posY
        case @state
        when :idle
            @tileset[DIRECTIONS_TILES[@direction]]
        when :moving
            @tileset[DIRECTIONS_TILES[@direction] + (Gosu.milliseconds / 175) % 4]
        when :stun
            @stun[DIRECTIONS_TILES[@direction] + (Gosu.milliseconds / 175) % 4]
        end        
        .draw(posX, posY, 0)
    end
    def move_to x, y, &complete_handler
        @state = :moving
        p "robert move to #{x}, #{y}"
        initial_pos = @position
        target_pos = Vector2.new x, y
        
        @state = check_state_before_new_mouvement target_pos
        
        if @state == :stun
            say "Ouch!!!"
            @root.plan_action(STUN_TIME) do
                @state = :idle
                complete_handler.call
            end           
            return
        end  

        @root.animate(0.5, on_progression: ->(linear_progress)do        
            ease_progress = Transition.smooth_progression linear_progress       
            @position = initial_pos + (target_pos - initial_pos)*ease_progress     
        end, on_finish: -> {
            @state = :idle
            complete_handler.call
        })   
    end
    def check_state_before_new_mouvement target_pos
        element = @root.level.maps.first.element_at(target_pos)
        solid = element != nil ? element.solid? : false

        solid ? :stun : :moving
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
    def turn_left &complete_handler
        case @direction
        when :up 
            @direction = :left
        when :right 
            @direction = :up
        when :down 
            @direction = :right
        when :left 
            @direction = :down
        end
        sleep 0.25
        complete_handler.call
    end
    def turn_right &complete_handler
        case @direction
        when :up 
            @direction = :right
        when :right 
            @direction = :down
        when :down 
            @direction = :left
        when :left 
            @direction = :up
        end
        sleep 0.25
        complete_handler.call
    end
    def say text
        casted_text = text.to_s
        puts "Say:|| #{casted_text}"
        @root.whats_arbre.push_message(casted_text)
    end
end