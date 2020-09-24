require 'gosu'
require_relative '../../core/tools/vector'
class RectRenderTests < Gosu::Window
    def initialize
        super 1280, 720
        @rect1 = Rectangle2.new(400,200,400,400)
        @rect2 = Rectangle2.new(0,0,300,300)
    end
    def draw
        @rect2.x, @rect2.y = mouse_x, mouse_y
        draw_my_rect(@rect1, Gosu::Color::BLUE)
        draw_my_rect(@rect2, Gosu::Color::RED)
        
        if(rect3 = @rect1.intersection @rect2)
            draw_my_rect(rect3, Gosu::Color::GREEN)
        end
    end
    def draw_my_rect rectangle, color
        Gosu.draw_rect(rectangle.x, rectangle.y, rectangle.width, rectangle.height, color)
    end
end
RectRenderTests.new.show
