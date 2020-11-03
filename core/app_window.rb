require 'gosu'
#editor
class AppWindow < Gosu::Window
    attr_reader :keys_down
    def initialize
        super 1280, 720, {resizable: true}
        self.caption = "ProgCraft - The Level Editor 🤩"
        @manager = EditorManager.new self
        @keys_down = [] #allowing for sub-frame key press
    end
    def update
        #time
        time = Time.now.to_f
        delta_time = time - (@last_frame_stamp || time)
        @last_frame_stamp = time

        @manager.update delta_time

        #res change
        if @current_window_width != self.width || @current_window_height != self.height
            puts "resolution changed! #{self.width} #{self.height}"
            @current_window_width, @current_window_height = self.width, self.height
            @manager.apply_constraints
        end
    end
    def button_down id
        @keys_down.push id
        @manager.events_manager.update
    end
    def button_up id
        @keys_down -= [id]
        @manager.events_manager.update
    end
    def mouse_pos
        Vector2.new(self.mouse_x, self.mouse_y)
    end
    def draw
        @manager.render
    end
    def needs_cursor?
        true
    end
end
LevelEditorWindow.new.show