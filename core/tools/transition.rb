class Transition
    def initialize root, start_stamp:, duration:, handler:, completion_handler:
        @root, @start_stamp, @duration, @handler, @completion_handler = root, start_stamp, duration, handler, completion_handler
    end
    def cancel
        @root.cancel_animation(self)
    end
    def update time
        return if time < @start_stamp #not started yet
        progression = ((time - @start_stamp) / @duration).clamp(0,1)
        @handler.call progression
        if progression == 1
            @completion_handler.call if @completion_handler
            self.cancel
        end
    end
    def self.smooth_progression progression, timing_function = :ease
        return progression * progression * (3 - 2 * progression) if timing_function == :ease
        progression
    end
end