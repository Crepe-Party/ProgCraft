require_relative 'ui_elements/drawables/sprite'
require_relative 'ui_elements/ui_element'
require_relative 'tools/vector'
require_relative 'config'
class Robert < GameObject
    attr :start_direction, :tileset, :tileset_height, :tileset_width, :tile
    attr_accessor :speed, :state, :direction, :position
    attr_reader :inventory
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

    def initialize root, x = 0, y = 0
        @root = root
        @position = @start_pos = Vector2.new(x, y)
        self.start_direction = :right
        @tileset = Gosu::Image.load_tiles(File.join(Config::ASSETS_DIR, 'robert.png'), 64, 64)
        @stun = Gosu::Image.load_tiles(File.join(Config::ASSETS_DIR, 'robert_stun.png'), 64, 64)    
        self.inventory = []    
        @speed = 1
        reset
    end    
    def reset
        @root.cancel_animation @current_animation if @current_animation
        @inventory = []
        @state = :idle
        @direction = @start_direction
        set_pos(@start_pos.x, @start_pos.y)
    end
    def set_pos x, y
        @position.x = x
        @position.y = y
    end
    def set_origin x, y
        @start_pos.x = x
        @start_pos.y = y
    end
    def start_direction= new_direction
        @start_direction = new_direction
        @direction = new_direction
    end
    def inventory= inventory
        @inventory = inventory if inventory.instance_of? Array
        @root.inventory_updated if defined? @root.inventory_updated
    end
    # put object in inventory
    def take        
        element = @root.level.maps.first.element_at @position
        
        unless element.is_a? Interactable 
            say("I can't pick it up!") 
            return
        end
        @inventory << element    
        @root.level.maps.first.game_objects.delete(element)
        @root.inventory_updated if defined? @root.inventory_updated
    end
    def drop object = nil
        object = @inventory.last unless object      
        unless object
            say("My inventory is empty...")
            return nil
        end
        @inventory.slice!(@inventory.index(object))
        object.position = @position.clone
        @root.inventory_updated if defined? @root.inventory_updated
        return object
    end
    def give object, quantity = 1
        raise "give required an interactible GameObject" unless object.is_a? Interactable
        quantity.times { @inventory << object.clone }
        @root.inventory_updated if defined? @root.inventory_updated   
        return object
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
        
        @state = is_clear_position(target_pos) ? :moving : :stun
        
        if @state == :stun
            say "Ouch!!!"
            @root.plan_action(STUN_TIME) do
                @state = :idle
                complete_handler.call
            end           
            return
        end  

        @current_animation = @root.animate(0.5 / @speed, timing_function: :ease, on_progression: ->(progress) do        
            @position = initial_pos + (target_pos - initial_pos)*progress     
        end, on_finish: -> do
            @state = :idle
            complete_handler.call
        end)   
    end
    def is_clear_position target_pos
        map = @root.level.maps.first
        return false if map.outside_the_area? target_pos

        element = map.element_at target_pos
        element.nil? ? true : !element.solid?
    end
    def is_clear_path
        to_pos = front_pos @direction
        is_clear_position to_pos
    end
    def is_clear_left
        to_pos = front_pos look_at(:left)  
        is_clear_position to_pos
    end
    def is_clear_right
        to_pos = front_pos look_at(:right)
        is_clear_position to_pos
    end
    def on_an_object
        @root.level.maps.first.element_at @position
    end
    # exec method
    def move_forward &complete_handler
        to_pos = front_pos(@direction)        
        move_to(to_pos.x, to_pos.y, &complete_handler)
    end
    def front_pos direction
        to_pos = @position.clone
        case direction
        when :up then to_pos.y -= 1
        when :right then to_pos.x += 1
        when :down then to_pos.y += 1
        when :left then to_pos.x -= 1
        end
        to_pos
    end
    # robert turn :right, :left or :back
    def turn direction, &complete_handler
        @direction = look_at direction
        sleep 0.25 / @speed
        complete_handler.call
    end
    # return direction when he look right, left or behind
    def look_at direction = nil
        return @direction if direction.nil?

        case @direction
        when :up 
            target_direction = direction == :right ? :right : direction == :left ? :left : :down
        when :right 
            target_direction = direction == :right ? :down : direction == :left ? :up : :left
        when :down 
            target_direction = direction == :right ? :left : direction == :left ? :right : :up
        when :left 
            target_direction = direction == :right ? :up   : direction == :left ? :down : :right
        end
        target_direction
    end

    def say text
        casted_text = text.to_s
        puts "Say:|| #{casted_text}"
        @root.plan_action{@root.whats_arbre.push_message(casted_text)} #why plan action: idk
    end

    def spin duration: 2.0, rotations: 5, direction: :right, on_finish: nil
        total_turns = rotations * 4
        turns_done = 0
        @current_animation = @root.animate(duration, on_progression: ->(progress) do 
            if(progress * total_turns > turns_done )
                @direction = look_at direction
                turns_done += 1
            end
        end, on_finish: on_finish)
    end

    def self.default_texture
        "robert_64x.png"
    end
    def self.pretty_s
        "Robert"
    end
end