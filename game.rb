require 'gosu'
require_relative 'core/game/game_manager'
#editor
class GameWindow < Gosu::Window
    attr_reader :keys_down
    def initialize
        super 1800, 900, {resizable: true}
        self.caption = "ProgCraft - The Game 🤩"
        @game = GameManager.new self
        @current_window_width
        @current_window_height

        @keys_down = [] #allowing for sub-frame key press
    end
    def update
        #time
        time = Time.now.to_f
        delta_time = time - (@last_frame_stamp || time)
        @last_frame_stamp = time

        @game.update delta_time

        #res change
        if @current_window_width != self.width || @current_window_height != self.height
            puts "resolution changed! #{self.width} #{self.height}"
            @current_window_width, @current_window_height = self.width, self.height
            @game.apply_constraints
        end
    end
    def button_down id
        @keys_down.push id
        @game.events_manager.update
    end
    def button_up id
        @keys_down -= [id]
        @game.events_manager.update
    end
    def mouse_pos
        Vector2.new(self.mouse_x, self.mouse_y)
    end
    def draw
        @game.render
    end
    def needs_cursor?
        true
    end
end
GameWindow.new.show