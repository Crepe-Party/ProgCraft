require_relative 'interactable'
module GameObjects
    class Apple < Interactable
        def self.default_texture
            "apple_64x.png"
        end        
    end
    class Axe < Interactable
        
    end
    class Bush < GameObject
        def self.default_texture
            "bush_64x.png"
        end
        def solid?
            true
        end
    end
    class Door < Interactable

    end
    class Log < Interactable

    end
    class Tree < Interactable
        def solid?
            true
        end
    end
    class PineCone < Interactable
        def self.default_texture
            "pine_cone_64x.png"
        end
        def self.pretty_s
            "Pine cone"
        end
    end
    class Wall < GameObject
        def solid?
            true
        end
        def self.default_texture
            "wall_64x.png"
        end
    end
    class Letter < GameObject
        attr_accessor :letter, :font, :color, :position
        def initialize(position:Vector2(0,0), letter:1, font: Gosu::Font.new(64, name: Gosu::default_font_name), color: Gosu::Color::BLACK)
            @letter = letter
            @font = font
            @color = color
            @position = position
        end 
        def draw x = @position.x, y = @position.y
            rendered_text = @letter.to_s
            x += (64 - @font.text_width(rendered_text)) / 2
            @font.draw_text(rendered_text, x, y, 0, 1, 1, @color)
        end
    end
end
