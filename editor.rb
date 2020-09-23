require 'gosu'
require_relative 'core/editor/editor_manager'
#editor
class LevelEditorWindow < Gosu::Window
    attr_reader :keys_down
    def initialize
        super 1280, 720, {resizable: true}
        self.caption = "ProgCraft - The Level Editor 🤩"
        @editor = EditorManager.new self
        @current_window_width; @current_window_height

        @keys_down = []

        puts "#{@current_window_width} #{@current_window_height}"
    end
    def update
        delta_time = self.update_interval / 1000
        @editor.update delta_time

        #res change
        if @current_window_width != self.width || @current_window_height != self.height
            puts "resolution changed! #{self.width} #{self.height}"
            @current_window_width, @current_window_height = self.width, self.height
            @editor.apply_constraints
        end

        #keys
        released_keys = []
        @keys_down.each{ |key_id|
            released_keys.push key_id if button_down? key_id
        }
        @keys_down -= released_keys
    end
    def button_down id
        @keys_down.push id
        @editor.events_manager.update
    end
    def draw
        @editor.render
    end
    def needs_cursor?
        true
    end
end
LevelEditorWindow.new.show