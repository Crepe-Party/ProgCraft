class List < UIElement
    attr_reader :builder, :data
    #elements class should implement "Listable"
    def initialize game, element_class, &constraint
        raise 'element_class does not contain Listable module' unless element_class.included_modules.include? Listable
        self(game, &constraint)
        @element_class = element_class
        @list_elements = []
    end
    def build
    end
    def data= new_data
        @data = new_data
        @list_elements = new_data.map do |datum|
            elem_rect = @element
            element_class.new @game
        end
    end
end

module Listable
    def 
      raise "Not implemented"
    end
end
