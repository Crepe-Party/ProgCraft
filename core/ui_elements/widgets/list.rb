class List < UIElement
    attr_reader :element_class, :data, :direction, :spacing, :start_offset
    #elements class should implement "Listable"
    def initialize root, element_class, direction: :vertical, spacing: 0, start_offset: 0, parent_element: nil, &constraint
        #direction: :vertical, :horizontal, :wrap
        raise 'element_class does not contain Listable module' unless element_class.included_modules.include? Listable
        super(root, parent_element: parent_element, &constraint)
        @element_class, @direction, @spacing, @start_offset = element_class, direction, spacing, start_offset
        @list_elements = []
        @data = []
    end
    def build
    end
    def render clipping_rect: nil, extra_elements: []
        super extra_elements: @list_elements + extra_elements, clipping_rect: clipping_rect
    end
    def apply_constraints
        return unless @root.ready_for_constraints
        super
        previous_rect = @rectangle.relative_to(y: @start_offset - @spacing).assign!(height: 0) if @direction == :vertical
        previous_rect = @rectangle.relative_to(x: @start_offset - @spacing).assign!(width: 0) if @direction == :horizontal
        @list_elements.each{|elem| previous_rect = elem.apply_list_contraints previous_rect}
    end
    def data= new_data
        @data = new_data
        #remove events for unused elements
        (@list_elements[new_data.length...@list_elements.length] || []).each{|elem| @root.events_manager.remove_events elem}
        #build list
        @list_elements = new_data.each_with_index.map do |datum, index|
            #reuse element if availible
            elem = @list_elements[index] || @element_class.new(@root, parent_list: self, index: index)
            #reassign data if needed
            elem.data = datum unless elem.data == datum
            elem
        end

        #propagate content change
        self.apply_constraints

        if(@list_elements.empty?)
            @rectangle.width = 0 if @direction == :horizontal
            @rectangle.height = 0 if @direction == :vertical
        else
            @rectangle.width = (2*@spacing + (@list_elements.last.rectangle.right - @rectangle.x)) if @direction == :horizontal
            @rectangle.height = (2*@spacing + (@list_elements.last.rectangle.bottom - @rectangle.y)) if @direction == :vertical
        end
        
        # puts "reapply_constraints #{@rectangle.width} , #{@rectangle.height}"
        #propagate size change to parents. may be overkill
        # @root.apply_constraints if @root.ready_for_constraints #TODO: maybe overkill?
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
    def apply_list_contraints previous_rect
        raise "This method should only be called by a list builder" unless @parent_list
        raise "Listable item should use the list_constraint method instead of external constraints for positionning" if @constraint
        @rectangle.assign!(list_constraint @parent_list.rectangle)
        if @parent_list.direction == :vertical
            @rectangle.y += (previous_rect.bottom + @parent_list.spacing)
            # @rectangle.y = @parent_list.rectangle.y + @parent_list.start_offset + (@rectangle.height + @parent_list.spacing) * @index 
        else
            @rectangle.x += (previous_rect.right + @parent_list.spacing)
            # @rectangle.x = @parent_list.rectangle.x + @parent_list.start_offset + (@rectangle.width + @parent_list.spacing) * @index
        end
        apply_constraints
        return @rectangle
    end
    def data= data
        @data = data
        update_data data
    end
end