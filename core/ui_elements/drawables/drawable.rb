require_relative '../ui_element'
class Drawable < UIElement
    def render clipping_rect: nil
        @clipping_rect = if not @overflow_hidden
            clipping_rect
        elsif clipping_rect
            clipping_rect.intersection(@rectangle)
        else
            @rectangle
        end
        [self]
    end
    def draw_with_clipping
        if @clipping_rect
            Gosu.clip_to(@clipping_rect.x, @clipping_rect.y, @clipping_rect.width, @clipping_rect.height) do 
                draw
            end
        else
            draw
        end
    end
    def draw
        
    end
end