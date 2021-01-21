require_relative '../tools/vector'
class UIElement
    attr_accessor :rectangle, :overflow, :should_render
    attr_reader :sub_elements, :root, :parent_element
    def initialize root, rectangle = nil, parent_element: nil, &constraint
        @root, @parent_element = root, parent_element
        @rectangle = rectangle || Rectangle2.new
        self.constrain(&constraint) if constraint
        @overflow = :visible
        @should_render = true
        @sub_elements = {}

        setup
        build
    end
    def setup
    end
    def build
    end
    def update dt
        @sub_elements.each{ |elem_name, sub_elem| sub_elem.update dt }
    end
    def render extra_elements: nil, clipping_rect: nil
        return [] unless @should_render
        #overflow clipping
        if @overflow == :hidden
            if clipping_rect
                unless (clipping_rect = clipping_rect.intersection @rectangle)
                    #nothing left to render
                    return []
                end
            else
                clipping_rect = @rectangle
            end
        end
        to_render = @sub_elements.map{ |elem_name, sub_elem| sub_elem.render clipping_rect: clipping_rect }
        if extra_elements
            to_render += extra_elements.map{ |sub_elem| sub_elem.render(clipping_rect: clipping_rect) } if extra_elements.instance_of? Array
            to_render += extra_elements.map{ |elem_name, sub_elem| sub_elem.render(clipping_rect: clipping_rect) } if extra_elements.instance_of? Hash
        end
        to_render
    end
    def apply_constraints
        return unless @root.ready_for_constraints
        @rectangle.assign!(@constraint.call(self)) if @constraint
        @sub_elements.each{ |elem_name, sub_elem| sub_elem.apply_constraints }
    end

    def constrain &constraint
        @constraint = constraint
        self
    end

    def add_event type, options = {}, &handler
        @root.add_event(self, type, options, &handler)
        self
    end

    #default rect bg
    def background_color= color
        if self.background_elem
            self.background_elem.color = color
        else
            require_relative 'drawables/rectangle'
            @sub_elements[:background_color] = Rectangle.new(@root, color){ @rectangle }
        end
    end
    def background_elem
        @sub_elements[:background_color]
    end
    def background_color
        @sub_elements[:background_color].color
    end

    def remove_sub_element key
        raise "invalid elem key" unless elem = @sub_elements[key]
        @root.events_manager.remove_events elem
        @sub_elements.delete(key)
    end

    def [] key
        self.sub_elements[key]
    end

    def inspect
        #for circular references reason
        "UIElement{#{self.class}}"
    end
end