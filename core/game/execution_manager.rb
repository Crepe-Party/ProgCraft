class ExecutionManager
    CLEARANCE_CHECK_INTERVAL = 1/10.0
    def initialize player, root
        @player = player
        @root = root
        @execution = self
        @last_instruction_finished = true
        @is_paused = true
        @running_program_thread = nil
        # @program_text = "puts 'WARNING : program empty'"
        @program_text = "walk_forward()"
    end
    def program_text= program_text
        stop
        @player.reset
        @program_text = program_text
    end
    def start
        p "start_program"
        @last_instruction_finished = true
        @is_paused = false
        @running_program_thread = Thread.new do
            eval @program_text
        end
    end
    def stop
        @running_program_thread.exit if @running_program_thread
        @running_program_thread = nil
    end
    def play
        start unless @running_program_thread
        @is_paused = false
    end
    def pause
        @is_paused = true
    end
    def instruction_finished
        @last_instruction_finished = true
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
        wait_for_clearance
        puts "walk forward"
        @player.move_forward{self.instruction_finished}
    end
    def turn_right
        wait_for_clearance
        puts "turn right"
        @player.turn_right
        instruction_finished
    end
    def turn_left
        puts "turn left"
        wait_for_clearance
        @player.turn_left
        instruction_finished
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