require 'pp'
require_relative 'elements/editor_ui'
require_relative '../events/events_manager'
class EditorManager
    attr_reader :window, :editor_ui
    def initialize window
        @events_manager = EventsManager.new window
        @window = window
        @editor_ui = EditorUI.new self, Rectangle2.new(0,0)
    end
    def update dt
        @editor_ui.update dt
        @events_manager.update
    end
    def render
        # final draw
        elements_to_draw = @editor_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw_with_clipping}
    end
    def apply_constraints
        @editor_ui.rectangle.width = window.width
        @editor_ui.rectangle.height = window.height
        @editor_ui.apply_constraints
    end
    
    def add_event element, type, options = {}, &handler
        @events_manager.add_event(element, type, options, handler)
    end
end