require 'pp'
require_relative 'elements/editor_ui'
class EditorManager
    attr_reader :window
    def initialize window
        @event_handlers=[]
        @window = window
        @editor_ui = EditorUI.new self, Rectangle2.new(0,0)
    end
    def update dt
        @editor_ui.update dt
    end
    def render
        # final draw
        elements_to_draw = @editor_ui.render.flatten
        elements_to_draw.each{|drawable| drawable.draw}
    end
    def apply_constraints
        @editor_ui.rectangle.width = window.width
        @editor_ui.rectangle.height = window.height
        @editor_ui.apply_constraints
    end
    def register_event_listener type, element, handler
        @event_handlers.push(EventHandler.new type, element, handler)
    end
    def on_click_event evt
        @event_handlers.each{|hdl| hdl.trigger evt}
    end
end
class EventHandler
    def initialize type, element, handler
        @type, @element, @handler = type, element, handler
    end

    def trigger evt
        pp @element.rectangle, evt[:position]
        @handler.call evt if @element.rectangle.contains? evt[:position]
    end
end