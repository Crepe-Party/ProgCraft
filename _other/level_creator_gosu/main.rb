require 'gosu'
require_relative 'vector2'
require_relative 'elements/button'
class LevelEditorWindow < Gosu::Window
    def initialize
        super 1280, 720, {resizable: true}
        self.caption = "ProgCraft Editor"
        @window_element = WindowElement.new
    end
    
    def update
        @window_element.update
    end
    
    def draw
        sprite_elements = @window_element.draw
        sprite_elements.each do |sprite_elem|
            sprite_elem.sprite.draw
        end
    end

    #Show the mouse
    def needs_cursor?
        true
    end

    public
    def add_event (type:, x:, y:, width:, height:)
        case type
        when :click 
        else
            raise Exception.new("invalid event type #{type.to_s}")
        end
    end
end

LevelEditorWindow.new.show