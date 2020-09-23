require 'gosu'
require_relative 'core/editor/editor_manager'
#editor
class LevelEditorWindow < Gosu::Window
    def initialize
        super 1280, 720, {resizable: true}
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
    def button_down id
        #TODO: remove test scroll
        @editor.editor_ui.sub_elements[:objects_menu].scroll_offset-=30 if id == Gosu::MS_WHEEL_DOWN 
        @editor.editor_ui.sub_elements[:objects_menu].scroll_offset+=30 if id == Gosu::MS_WHEEL_UP 
    end
    def draw
        @editor.render
    end
    def needs_cursor?
        true
    end
end
LevelEditorWindow.new.show