require 'gosu'
require_relative 'core/editor/editor_manager'
#editor
class LevelEditorWindow < Gosu::Window
    def initialize
        super 1280, 720, {resizable: true}
        self.caption = "ProgCraft - The Level Editor 🤩"
        @editor = EditorManager.new self
        @current_window_width; @current_window_height
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
    end
    def draw
        @editor.render
    end
    def needs_cursor?
        true
    end
end
LevelEditorWindow.new.show