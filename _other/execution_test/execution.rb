require_relative 'commands'
class ExecutionManager
    CLEARANCE_CHECK_INTERVAL = 1/10.0
    attr_reader :game, :execution
    def initialize game
        @game = game
        @execution = self
        @last_instruction_finished = true
        @is_paused = true
        @running_program_thread = nil
        @program_text = nil
    end
    def wait_for_clearance
        p "waiting for clearance"
        sleep CLEARANCE_CHECK_INTERVAL until @last_instruction_finished and !@is_paused
        p "cleared!"
        @last_instruction_finished = false
    end
    def instruction_finished
        @last_instruction_finished = true
    end
    def load_program name
        file_path = File.join(File.dirname(__FILE__), "codes", "#{name}.rb")
        @program_text = File.read(file_path)
        p "program loaded:", @program_text
    end
    def start_program
        p "start_program"
        @last_instruction_finished = true
        @is_paused = false
        @running_program_thread = Thread.new do
            p "program thread started"
            eval @program_text
        end
    end
    def stop_program
        p "stop_program"
        @running_program_thread.exit if @running_program_thread
    end
    def toggle_pause
        @is_paused ^= true
    end
end