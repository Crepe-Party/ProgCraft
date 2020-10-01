require 'gosu'
require_relative '../../core/tools/vector'
require_relative 'execution'
require_relative 'robert'

TILE_SIZE = 150
class ExecTestWindow < Gosu::Window
    attr_reader :execution_manager, :robert
    def initialize
        super 1280, 720
        @btn1rct = Rectangle2.new 10, 10, 100, 50
        @btn2rct = Rectangle2.new @btn1rct.right + 10, 10, 100, 50
        @btn3rct = Rectangle2.new @btn2rct.right + 10, 10, 100, 50
        @button_font = Gosu::Font.new @btn1rct.height

        @execution_manager = ExecutionManager.new self
        @robert = Robert.new 0,0
    end
    def needs_cursor?
        true
    end
    def update
        @robert.update
    end
    def draw
        # top menu
        top_menu_height = @btn1rct.bottom + @btn1rct.y
        Gosu.draw_rect(0, 0, self.width, top_menu_height, Gosu::Color::GRAY)
        Gosu.draw_rect(@btn1rct.x, @btn1rct.y, @btn1rct.width, @btn1rct.height, Gosu::Color::GREEN)
        Gosu.draw_rect(@btn2rct.x, @btn2rct.y, @btn2rct.width, @btn2rct.height, Gosu::Color::YELLOW)
        Gosu.draw_rect(@btn3rct.x, @btn3rct.y, @btn3rct.width, @btn3rct.height, Gosu::Color::RED)
        #game zone
        Gosu.clip_to(0, top_menu_height, self.width, self.height - top_menu_height) do
            Gosu.draw_rect(0, top_menu_height, self.width, self.height - top_menu_height, Gosu::Color::rgba(0,128,0,255)) #bg
            #grid
            1.upto(self.width / TILE_SIZE) do |index|
                Gosu.draw_line index*TILE_SIZE, top_menu_height, Gosu::Color::GRAY, index*TILE_SIZE, self.height, Gosu::Color::GRAY
            end
            1.upto(self.height / TILE_SIZE) do |index|
                Gosu.draw_line 0, top_menu_height + index*TILE_SIZE, Gosu::Color::GRAY, self.width, top_menu_height + index*TILE_SIZE, Gosu::Color::GRAY
            end
            robert.draw top_menu_height
        end
    end
    def button_down id
        super id
        if id == Gosu::MsLeft
            play_btn_pressed if @btn1rct.includes? mouse_x, mouse_y
            pause_btn_pressed if @btn2rct.includes? mouse_x, mouse_y
            stop_btn_pressed if @btn3rct.includes? mouse_x, mouse_y
        end
    end
    def play_btn_pressed
        p "play_btn_pressed"
        @execution_manager.stop_program
        @robert.reset
        @execution_manager.load_program("tour_de_piste")
        @execution_manager.start_program
    end
    def pause_btn_pressed
        p "pause_btn_pressed"
        @execution_manager.toggle_pause
    end
    def stop_btn_pressed
        p "stop_btn_pressed"
        @execution_manager.stop_program
        @robert.reset
    end
end
def draw_centered_text(font, string, x, y, width, height, color)
    text_width = font.text_width(string, 1)
    font.draw_text(string, x + (width - text_width) / 2, y + ((height - font.height) / 2), 0, 1, 1, color)
end
$game = ExecTestWindow.new
$game.show
$execution = $game.execution_manager