require 'gosu'
class CameraRenderTests < Gosu::Window
    def initialize
        super 1280, 720
        @scale_factor = 1
        @rotation_angle = 0
    end
    def update
        @rotation_angle+=3 if button_down? Gosu::MsRight
        @rotation_angle-=3 if button_down? Gosu::MsLeft
    end
    def draw
        center_x = self.width/2
        center_y = self.height/2
        #interface
        Gosu.draw_rect(0,0,300,50,Gosu::Color::WHITE)
        Gosu.clip_to 200,100,900,500 do
            #bg
            Gosu.draw_rect(0,0,self.width, self.height, Gosu::Color::GRAY)
            #translate
            Gosu.translate(self.mouse_x - center_x , self.mouse_y - center_y) do
                Gosu.scale(@scale_factor, @scale_factor, center_x, center_y) do
                    Gosu.rotate(@rotation_angle, center_x, center_y) do
                        Gosu.draw_rect(300,400,50,60, Gosu::Color::BLUE);
                        Gosu.draw_rect(600,200,100,60, Gosu::Color::BLUE);
                        Gosu.draw_rect(self.width/2 - 50,self.height/2 - 50,100,100, Gosu::Color::GREEN);
                    end
                end
            end
        end
    end
    # def render_transform 
    def button_down id
        super id
        @scale_factor *= 1.2 if id == Gosu::MS_WHEEL_UP
        @scale_factor /= 1.2 if id == Gosu::MS_WHEEL_DOWN
    end
end
CameraRenderTests.new.show