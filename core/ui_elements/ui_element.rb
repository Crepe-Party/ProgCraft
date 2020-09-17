require_relative '../tools/vector.rb'
class UIElement
    attr_accessor :position
    def initialize game, position=Vector2.new
        @game, @position = game, position
        @sub_elements = {}
        build
    end
    def build

    end
    def update dt
        @sub_elements.map{|sub_elem| sub_elem.update dt}
    end
    def draw
        @sub_elements.map{|sub_elem| sub_elem.draw}
    end
end