require_relative '../config'
class ExecutionManager
    CLEARANCE_CHECK_INTERVAL = 1/20.0
    SLEEP_BETWEEN_INSTRUCTIONS = 0.3
    def initialize robert, root
        @robert = robert
        @root = root
        @execution = self
        @last_instruction_finished = true
        @is_paused = true
        @running_program_thread = Thread.new{}
        @program_text = "puts 'WARNING : program empty'"
    end
    def program_text= program_text
        stop
        @robert.reset
        @program_text = program_text
    end
    def start
        @last_instruction_finished = true
        @is_paused = false
        @running_program_thread = Thread.new do
            eval @program_text
        end
    end
    def stop
        @running_program_thread.exit
    end
    def play
        if @running_program_thread.status != "run" && @running_program_thread.status != "sleep"
            stop
            @robert.reset
            start
        end
        @is_paused = false
    end
    def pause
        @is_paused = true
    end
    def next_step
        if (@running_program_thread.status != "run" && @running_program_thread.status != "sleep") || @is_paused
            play
            sleep CLEARANCE_CHECK_INTERVAL+0.05
            pause
        end
    end
    def instruction_finished
        sleep SLEEP_BETWEEN_INSTRUCTIONS
        @last_instruction_finished = true
    end
    def wait_for_clearance
        sleep CLEARANCE_CHECK_INTERVAL until @last_instruction_finished and !@is_paused #loop until last instruction finished with interval
        @root.update_line_display caller_locations(2).to_s.split(":")[1]
        @last_instruction_finished = false
    end
    # game functions
    Dir.glob(File.join(Config::MY_FUNCTIONS_DIR, "*.rb")).each do|file|
        require_relative file
    end
end