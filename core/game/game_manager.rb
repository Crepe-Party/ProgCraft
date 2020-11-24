require 'pp'
require_relative '../app_manager'
require_relative 'elements/game_ui'
require_relative '../level'
require_relative '../player'
class GameManager < AppManager
    attr :level, :player
    def initialize window
        super window, main_ui_class: GameUI
        @busy_string = "Loading..."
        @level = Level.new
        @player = Player.new(0, 0)
        @main_ui.sub_elements[:map_game].player = @player
    end
    def play
        
    end
    def pause
    
    end
    def next
    
    end
    def load_map path_file
        @level_available = @level.load path_file
        unless @level_available.nil?
            @main_ui.sub_elements[:map_name].path_file = path_file
            @main_ui.sub_elements[:map_game].selected_map = @level.maps[0]
            # @player.set_pos @level.maps[0].robert_spawn.x, @level.maps[0].robert_spawn.y
        end
    end
    def load_program path_file
        unless path_file.empty?
            @main_ui.sub_elements[:code_menu].path_file = path_file
            @main_ui.sub_elements[:code_display].load path_file
        end
    end
    def edit_program
        @main_ui.sub_elements[:code_menu].edit
    end 
end