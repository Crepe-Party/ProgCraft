class CodeExecution
    attr_accessor :code, :grid_game, :player
    def initialize player
        @player = player
    end
    def play

    # navigation functions
    def gps_x
        return @player.position.x
    end 
    def gps_y
        return @player.position.x
    end
    def is_clear_path
        return true
    end
    def is_clear_right
        return true
    end
    def is_clear_left
        return true
    end
    def walk_forward
        case @player.direction
            when 'north' @player.position.y -= 1
            when 'est' @player.position.x += 1
            when 'south' @player.position.y += 1
            when 'west' @player.position.x -= 1
        end
    end
    def turn_right
        case @player.direction
        when 'north' @player.direction = 'est'
        when 'est' @player.direction = 'south'
        when 'south' @player.direction = 'west'
        when 'west' @player.direction = 'north'
    end
    end
    def turn_left
        case @player.direction
        when 'north' @player.direction = 'west'
        when 'est' @player.direction = 'north'
        when 'south' @player.direction = 'est'
        when 'west' @player.direction = 'south'
    end
    # interaction functions
    def ask text
        puts text
    end
    def say text
        puts text
    end
    def detection
        return false
    end
end