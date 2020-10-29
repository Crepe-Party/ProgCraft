require_relative '../../ui_elements/widgets/grid_game_container'
class MapEditorDisplay < GridGameContainer
    def build
        super
        self.background_color = Gosu::Color::GREEN
        # @sub_elements[:test] = Rectangle.new(@root, Gosu::Color::RED){Rectangle2.new(@rectangle.right - 200, @rectangle.y + 100, 400, 100)}
    end
    def update dt
        super dt
        # puts dt
        cam_mv = dt * 200
        self.camera_position.y -= cam_mv if @root.window.button_down? Gosu::KB_UP
        self.camera_position.y += cam_mv if @root.window.button_down? Gosu::KB_DOWN
        self.camera_position.x -= cam_mv if @root.window.button_down? Gosu::KB_LEFT
        self.camera_position.x += cam_mv if @root.window.button_down? Gosu::KB_RIGHT
    end
end