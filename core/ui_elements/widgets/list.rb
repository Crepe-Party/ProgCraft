class List < UIElement
    attr_reader :builder, :data, :direction
    #elements class should implement "Listable"
    def initialize game, element_class, direction: :vertical, &constraint
        #direction: :vertical, :horizontal, :wrap
        raise 'element_class does not contain Listable module' unless element_class.included_modules.include? Listable
        super(game, &constraint)
        @element_class, @direction = element_class, direction
        @list_elements = []

        # ANONYMOUS CLASS
        # fred = Class.new do
        #     def meth1
        #       "hello"
        #     end
        #     def meth2
        #       "bye"
        #     end
        #   end
    end
    def build
    end
    def render clipping_rect: nil, extra_elements: []
        super extra_elements: @list_elements + extra_elements, clipping_rect: clipping_rect
    end
    def data= new_data
        @data = new_data
        @list_elements = new_data.map do |datum, index|
            puts datum #TODO: wolàà
            elem = @element_class.new @game
            puts "elem", elem.base_rect
            base_rect = @element_class.base_rect
            elem.constrain do
                rect = base_rect.clone
                if @direction == :vertical
                    rect.y = index * base_rect.height 
                    rect.x = @rectangle.x
                end   
                pp rect
                rect
            end
            elem.data = datum
            elem
        end
        self.apply_constraints
        new_data
    end
end

module Listable
    attr_reader :data
    def base_rect
        raise "Not implemented (or don't call super on this implementation)"
    end
    def build data
        raise "Not implemented (or don't call super on this implementation)"
    end
    def data= data

    end
end