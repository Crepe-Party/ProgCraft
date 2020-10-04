class List < UIElement
    attr_reader :builder, :data, :direction, :spacing, :start_offset
    #elements class should implement "Listable"
    def initialize root, element_class, direction: :vertical, spacing: 0, start_offset: 0, parent_element: nil, &constraint
        #direction: :vertical, :horizontal, :wrap
        raise 'element_class does not contain Listable module' unless element_class.included_modules.include? Listable
        super(root, parent_element: parent_element, &constraint)
        @element_class, @direction, @spacing, @start_offset = element_class, direction, spacing, start_offset
        @list_elements = []
    end
    def build
    end
    def render clipping_rect: nil, extra_elements: []
        super extra_elements: @list_elements + extra_elements, clipping_rect: clipping_rect
    end
    def apply_constraints
        return unless @root.ready_for_constraints
        super
        @list_elements.each(&:apply_list_contraints)
        #update rect size
        unless @aaaa
            @rectangle.width = 500
            @aaaa = true
            return
        end
    end
    def data= new_data
        @data = new_data
        # pp "new data", new_data
        @list_elements = new_data.each_with_index.map do |datum, index|
            # puts "datum", index, datum #TODO: wolàà
            elem = @element_class.new(@root, parent_list: self, index: index)
            elem.data = datum
            elem
        end
        #propagate content change
        self.apply_constraints

        @rectangle.width = (2*@spacing + (@list_elements.last.rectangle.right - @rectangle.x)) if @direction == :horizontal
        @rectangle.height = (2*@spacing + (@list_elements.last.rectangle.bottom - @rectangle.y)) if @direction == :vertical
        puts "reapply_constraints #{@rectangle.width} , #{@rectangle.height}"
        #propagate size change to parents. may be overkill
        @root.apply_constraints if @root.ready_for_constraints #TODO: maybe overkill?
        new_data
    end
end

module Listable #use include to use module
    attr_reader :data
    attr_accessor :index
    def initialize(root, *args, parent_list: nil, index: nil, &constraint)
        @parent_list, @index = parent_list, index
        super(root, *args, &constraint)
    end
    def update_data data
        raise "Not implemented (or don't call super in this implementation)"
    end
    def list_constraint parent_rect
        raise "Not implemented (or don't call super in this implementation)"
    end
    def apply_list_contraints
        raise "This method should only be called by a list builder" unless @parent_list
        raise "Listable item should use the list_constraint method instead of external constraints for positionning" if @constraint
        @rectangle.assign!(list_constraint @parent_list.rectangle)
        if @parent_list.direction == :vertical
            @rectangle.y = @parent_list.rectangle.y + @parent_list.start_offset + (@rectangle.height + @parent_list.spacing) * @index 
        else
            @rectangle.x = @parent_list.rectangle.x + @parent_list.start_offset + (@rectangle.width + @parent_list.spacing) * @index
        end
        apply_constraints
    end
    def data= data
        @data = data
        update_data data
    end
end