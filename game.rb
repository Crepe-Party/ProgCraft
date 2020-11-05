require_relative 'core/app_window'
require_relative 'core/game/game_manager'
#editor
class GameWindow < AppWindow
    attr_reader :keys_down
    def initialize
        super 1800, 900, {resizable: true}
        self.caption = "ProgCraft - The Game 🤩"
        @manager = GameManager.new self
    end
    def needs_cursor?
        true
    end
end
GameWindow.new.show