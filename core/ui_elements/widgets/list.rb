class List < UIElement
    attr_reader :builder, :data, :direction
    #elements class should implement "Listable"
    def initialize game, element_class, direction: :vertical, &constraint
        #direction: :vertical, :horizontal, :wrap
        raise 'element_class does not contain Listable module' unless element_class.included_modules.include? Listable
        self(game, &constraint)
        @element_class, @direction = element_class, direction
        @list_elements = []
    end
    def build
    end
    def render
        super extra_elems: @list_elements.map(&:render)
    end
    def data= new_data
        @data = new_data
        @list_elements = new_data.map do |datum, index|
            puts datum #TODO: wolàà
            elem_rect = @element_class
            element_class.new @game
            element_class.constrain{
                base_rect = element_class.base_rect.clone
                rect = Rectangle2.new
                # rect.y =  if direction == :vertical
            }
        end
    end
end

module Listable
    def base_rect
        raise "Not implemented (or don't call super on this implementation)"
    end
    def build data
        raise "Not implemented (or don't call super on this implementation)"
    end
end