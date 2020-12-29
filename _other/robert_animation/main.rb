require 'gosu'
require 'pp'
DIRECTIONS_TILES = {
    down:0,
    left:4,
    right:8,
    up:12,
}
class Animation < Gosu::Window
    def initialize
        @a=0
        super 1280, 720, {resizable: true}
        @robert_tiles = Gosu::Image.load_tiles("robert.png", 64, 64)
        @robert_stun = Gosu::Image.load_tiles("robert_stun.png", 64, 64)
        @animations
        @direction = :right
        @x, @y = 64, 64        
    end
    def needs_cursor?
        true
    end
    def update        
        move_x = 0
        move_y = 0
        @direction = :left if Gosu.button_down? Gosu::KB_LEFT 
        @direction = :right if Gosu.button_down? Gosu::KB_RIGHT
        @direction = :up if Gosu.button_down? Gosu::KB_UP
        @direction = :down if Gosu.button_down? Gosu::KB_DOWN
        move_x = @direction == :right ? 5 : -5 if @direction == :right || @direction == :left
        move_y = @direction == :down ? 5 : -5 if @direction == :down || @direction == :up
        if @x + move_x > 63 && @x + move_x < 500 && @y + move_y < 500 && @y + move_y > 63
            @x += move_x
            @y += move_y
            @stun = false
        else
            @stun = true
        end
        # tiles calculator
        @current_tile = DIRECTIONS_TILES[@direction] + (Gosu.milliseconds / 175) % 4
        
    end
    def button_down id
    end
    def button_up id
        close if id == Gosu::KB_ESCAPE 
    end
    def draw
        @stun ? @robert_stun[@current_tile].draw(@x, @y, 1) : @robert_tiles[@current_tile].draw(@x, @y, 1)
    end    
end
Animation.new.show