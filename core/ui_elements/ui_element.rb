require_relative '../tools/vector'
class UIElement
    attr_accessor :rectangle
    attr_reader :sub_elements
    def initialize game, rectangle = nil, &constraint
        @constraint = constraint if constraint
        @game = game
        #default rect
        @rectangle = rectangle || Rectangle2.new
        @sub_elements = {}
        build
    end
    def build

    end
    def update dt
        @sub_elements.each{|elem_name, sub_elem| sub_elem.update dt}
    end
    def render extra_elements: nil
        to_render = @sub_elements.map{|elem_name, sub_elem| sub_elem.render}
        to_render += extra_elements if extra_elements
        to_render
    end
    def apply_constraints
        @rectangle = @constraint.call if @constraint
        @sub_elements.each{|elem_name, sub_elem| sub_elem.apply_constraints}
    end

    def constrain &constraint
        @constraint = constraint
        self
    end
    
    #default rect bg
    def background_color= color
        require_relative 'drawables/rectangle'
        @sub_elements[:background_color] = Rectangle.new(@game, color){@rectangle}
    end
    def background_color
        @sub_elements[:background_color].color
    end
end