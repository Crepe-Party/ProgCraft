require 'pp'
require_relative '../app_manager'
require_relative 'elements/editor_ui'
require_relative '../level'
require_relative '../robert'
class Editor < AppManager
    attr :level, :robert, :selected_object_type
    def initialize 
        super 1280, 720, {resizable: true}, main_ui_class: EditorUI
        self.caption = "ProgCraft - The Level Editor 🤩"
        @busy_string = "Loading..."
        new_level
    end
    def load_map path_file
        return if path_file.empty?
        @level_available = @level.load path_file
        @main_ui[:top_bar].level_path = path_file
        if @level_available
            change_map(0)
        end
    end
    def new_level
        @level = Level.new
        change_map(0)
        @main_ui[:top_bar].level_path = nil
    end
    def change_map index
        @selected_map_index = index
        @main_ui[:map_editor].selected_map = @level.maps[index]
        #notify
        @main_ui[:contextual_menu].on_map_update
    end
    def save_map path_file
        return if path_file.empty?
        @level.save path_file
        @main_ui[:top_bar].level_path = path_file
    end
    def select_object object_type
        @selected_object_type = object_type
        objects_list = @main_ui[:objects_menu][:list]
        objects_list.data = objects_list.data.map{|datum| {**datum, selected: (datum[:object] == object_type)}}
    end
end