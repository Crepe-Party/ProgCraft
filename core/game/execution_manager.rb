require_relative '../config'
class ExecutionManager
    CLEARANCE_CHECK_INTERVAL = 1/60.0
    SLEEP_BETWEEN_INSTRUCTIONS = 0.3
    def initialize robert, root
        @robert = robert
        @root = root
        @execution = self
        @instruction_finished = true
        @is_paused = true
        @is_stepping = false
        @running_program_thread = Thread.new{}
        @program_text = "say 'WARNING : program empty'; raise 'program empty.'"
    end
    def program_text= program_text
        stop
        @robert.reset
        @program_text = program_text
    end
    def start
        @instruction_finished = true
        @is_paused = false
        @running_program_thread = Thread.new do
            begin
                eval(@program_text)
            rescue Exception => error
                @root.on_program_error(error)
            end
        end
    end
    def stop
        puts "stop"
        @running_program_thread.exit
        @robert.reset
    end
    def play
        puts "play", @running_program_thread.status
        unless @running_program_thread.alive?
            stop
            start
        end
        @is_paused = false
        @is_stepping = false
    end
    def pause
        @is_paused = true
    end
    def next_step
        puts "next step"
        play unless @running_program_thread.alive?
        @is_paused = false
        @is_stepping = true
    end
    def start_instruction(deeper = 0)
        @instruction_finished = false
        @root.update_line_display caller_locations(2+deeper).to_s.split(":")[1]
    end
    def finish_instruction
        @instruction_finished = true
        @is_paused = true if @is_stepping
    end
    def mark_instruction
        start_instruction(1)
        finish_instruction
        wait_for_clearance
    end
    def wait_for_clearance
        sleep CLEARANCE_CHECK_INTERVAL until @instruction_finished and !@is_paused #loop until availible to continue execution
    end
    # game functions
    Dir.glob(File.join(Config::MY_FUNCTIONS_DIR, "*.rb")).each do|file|
        require_relative file
    end
end