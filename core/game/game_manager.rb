require 'pp'
require_relative '../app_manager'
require_relative 'elements/game_ui'
require_relative '../level'
require_relative '../robert'
require_relative 'execution_manager'
class GameManager < AppManager
    attr :level, :robert
    def initialize window
        super window, main_ui_class: GameUI
        @busy_string = "Loading..."
        @level = Level.new
        @robert = Robert.new(0, 0)
        @main_ui.sub_elements[:map_game].robert = @robert
        @main_ui.sub_elements[:map_game].selected_map = @level.maps[0]
        @execution_manager = ExecutionManager.new(@robert, self)
    end
    def play
        @execution_manager.play
    end
    def pause
        @execution_manager.pause
    end
    def next
        puts "next instruction"
    end
    def load_map path_file
        @level_available = @level.load path_file
        unless @level_available.nil?
            @main_ui.sub_elements[:map_name].path_file = path_file
            @main_ui.sub_elements[:map_game].selected_map = @level.maps[0]
            @robert.set_origin @level.maps[0].robert_spawn.x, @level.maps[0].robert_spawn.y
        end
    end
    def load_program path_file
        unless path_file.empty?
            @main_ui.sub_elements[:code_menu].path_file = path_file
            @main_ui.sub_elements[:code_display].load path_file
            @execution_manager.program_text = @main_ui.sub_elements[:code_display].code
        end
    end
    def edit_program
        @main_ui.sub_elements[:code_menu].edit
    end 
end