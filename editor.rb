require 'gosu'
require_relative 'core/editor/manager'
#editor
class LevelEditorWindow < Gosu::Window
    def initialize
        super 1280, 720, {resizable: true}
        @editor = EditorManager.new
    end
    def update
        delta_time = self.update_interval / 1000
        @editor.update delta_time
    end
    def draw
        @editor.draw
    end
    def needs_cursor?
        true
    end
end
LevelEditorWindow.new.show