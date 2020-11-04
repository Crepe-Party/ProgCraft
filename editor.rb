require_relative 'core/app_window'
require_relative 'core/editor/editor_manager'
#editor
class LevelEditorWindow < AppWindow
    def initialize
        super 1280, 720, {resizable: true}
        self.caption = "ProgCraft - The Level Editor 🤩"
        @manager = EditorManager.new self
    end
    def needs_cursor?
        true
    end
    def drop filename        
        @editor.events_manager.drop filename
    end
end
LevelEditorWindow.new.show