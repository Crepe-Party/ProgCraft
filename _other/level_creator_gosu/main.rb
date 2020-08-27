require 'gosu'
require_relative 'elements/window'
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
end

LevelEditorWindow.new.show