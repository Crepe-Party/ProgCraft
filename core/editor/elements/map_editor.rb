require_relative '../../ui_elements/widgets/grid_game_container'
class MapEditorDisplay < GridGameContainer
    def build
        super
        self.background_color = Gosu::Color::GREEN
        self.add_event(:mouse_down, button: Gosu::MS_RIGHT) do |event|
            #delete element
            clicked_elem = game_object_at_grid_position(projected_grid_position(event[:position]))
            @selected_map.game_objects.delete(clicked_elem) if clicked_elem
        end
        self.add_event(:mouse_down, button: Gosu::MS_LEFT) do |event|
            grid_pos = projected_grid_position(event[:position])
            p grid_pos
            #select object
            if(obj = game_object_at_grid_position(grid_pos))
                puts "already an object here"
                select_object obj
                next
            end
            #add object
            unless @root.selected_object_type
                puts "no object type selected"
                next
            end
            new_obj = @root.selected_object_type.new(position: grid_pos)
            @selected_map.game_objects.push(new_obj)
        end
    end
    def select_object object
        puts "selecting a #{object.class.to_s}"
    end
    def zoomable?
        false
    end
end