require 'pp'
require_relative 'elements/editor_ui'
require_relative '../events/events_manager'
require_relative '../level'
class EditorManager
    attr_reader :window, :editor_ui, :events_manager
    attr :level
    def initialize window
        @events_manager = EventsManager.new window
        @window = window
        @editor_ui = EditorUI.new self, Rectangle2.new(0,0)
        @keys_down = []
        @level = Level.new
    end
    def update dt
        @editor_ui.update dt
        @events_manager.update
    end
    def render
        # final draw
        elements_to_draw = @editor_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
        # temp TODO remove
        @level.render 0
    end
    def apply_constraints
        @editor_ui.rectangle.width = window.width
        @editor_ui.rectangle.height = window.height
        @editor_ui.apply_constraints
    end
    def load_map path_file
        @level.load path_file
    end

    def add_event element, type, options = {}, &handler
        @events_manager.add_event(element, type, options, handler)
    end
end