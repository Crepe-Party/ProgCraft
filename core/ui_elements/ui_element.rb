require_relative '../tools/vector'
class UIElement
    attr_accessor :rectangle, :overflow
    attr_reader :sub_elements, :game
    def initialize game, rectangle = nil, &constraint
        @constraint = constraint if constraint
        @game = game
        @rectangle = rectangle || Rectangle2.new
        @overflow = :visible
        @sub_elements = {}
        build
    end
    def build

    end
    def update dt
        @sub_elements.each{|elem_name, sub_elem| sub_elem.update dt}
    end
    def render extra_elements: nil, clipping_rect: nil
        #overflow clipping
        if overflow == :hidden
            if clipping_rect
                unless(clipping_rect = clipping_rect.intersection @rectangle)
                    #nothing left to render
                    return {}
                end
            else
                clipping_rect = @rectangle
            end
        end
        to_render = @sub_elements.map{|elem_name, sub_elem| sub_elem.render clipping_rect: clipping_rect}
        if extra_elements
            to_render += extra_elements.map{|sub_elem| sub_elem.render(clipping_rect: clipping_rect)} if extra_elements.instance_of? Array
            to_render += extra_elements.map{|elem_name, sub_elem| sub_elem.render(clipping_rect: clipping_rect)} if extra_elements.instance_of? Hash
        end
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

    def add_event type, options = {}
        @game.add_event(self, type, options){yield}
        self
    end

    #default rect bg
    def background_color= color
        require_relative 'drawables/rectangle'
        @sub_elements[:background_color] = Rectangle.new(@game, color){@rectangle}
    end
    def background_elem
        @sub_elements[:background_color]
    end
    def background_color
        @sub_elements[:background_color].color
    end
end