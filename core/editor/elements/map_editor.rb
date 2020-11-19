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
    end
    def zoomable?
        false
    end
end