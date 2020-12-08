class ExecutionManager
    attr_accessor :program_text, :grid_game, :player
    CLEARANCE_CHECK_INTERVAL = 1/10.0
    def initialize player, root
        @player = player
        @root = root
        @execution = self
        @last_instruction_finished = true
        @is_paused = true
        @running_program_thread = nil
        @program_text = nil
    end
    def instruction_finished
        @last_instruction_finished = true
    end
    def start
        p "start_program"
        @last_instruction_finished = true
        @is_paused = false
        @running_program_thread = Thread.new do
            p "program thread started"
            eval @program_text
        end
    end
    def stop
        p "stop_program"
        @running_program_thread.exit if @running_program_thread
    end
    def toggle_pause
        @is_paused ^= true
    end
    def wait_for_clearance
        sleep CLEARANCE_CHECK_INTERVAL until @last_instruction_finished and !@is_paused
        @last_instruction_finished = false
    end
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
        @player.move_forward
    end
    def turn_right
        @player.turn_right
    end
    def turn_left
        @player.turn_left
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