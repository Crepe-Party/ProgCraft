require_relative '../ui_element'
require_relative 'button'
class Scrollable < UIElement
    attr_reader :scroll_offset
    SCROLL_BUTTONS_SIZE = 30
    MOUSE_SCROLL_FACTOR = 30
    BUTTON_SCROLL_FACTOR = 100
    def setup
        @no_scroll_elements = [:before_button, :after_button, :background_color] #if some elements don't scroll, add them in this list
    end
    def build
        #please call super() at the end of your build method to prevent sketchy behaviors with buttons
        @scrl_rect = Rectangle2.new
        @overflow = :hidden
        @scroll_offset = 0
        if scroll_buttons?
            @sub_elements[:before_button] = Button.new(@root, vertical? ? "▲" : "◄") do
                next Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.y + 5, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE) if vertical?
                next Rectangle2.new(@rectangle.x + 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
            end
            @sub_elements[:after_button] = Button.new(@root, vertical? ? "▼" : "►") do
                Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
            end
        end
        setup_scroll_events
    end
    def apply_constraints
        return unless @root.ready_for_constraints
        @rectangle.assign!(@constraint.call(self)) if @constraint
        @scrl_rect = @rectangle.clone
        @scrl_rect.y -= @scroll_offset if vertical?
        @scrl_rect.x -= @scroll_offset if horizontal?
        @scrl_rect.height = 0 #to prevent circular height references messing with scroll limit
        super
    end
    def setup_scroll_events
        add_event(:mouse_down, { button: Gosu::MS_WHEEL_DOWN }){ self.scroll_offset+=MOUSE_SCROLL_FACTOR; }
        add_event(:mouse_down, { button: Gosu::MS_WHEEL_UP }){ self.scroll_offset-=MOUSE_SCROLL_FACTOR; }
        if scroll_buttons?
            @sub_elements[:after_button].on_click{ self.scroll_to(self.scroll_offset + BUTTON_SCROLL_FACTOR, 0.1) }
            @sub_elements[:before_button].on_click{ self.scroll_to(self.scroll_offset - BUTTON_SCROLL_FACTOR, 0.1) }
        end
    end
    
    def scroll_offset= scroll_offset #number or :end
        scroll_to(scroll_offset, 0)
    end
    def scroll_to(position, animation_length=0.2, &completion)
        @current_scroll_animation&.cancel
        
        target_offset = (position == :end) ? self.scroll_size : position.clamp(0, self.scroll_size)
        if(animation_length == 0)
            @scroll_offset = target_offset
            self.apply_constraints
            self.apply_constraints #a second time because of some rendering logic issue with line breaks and lists
            completion&.call
            return
        end
        @current_scroll_animation = @root.animate(
            animation_length, 
            from: @scroll_offset, 
            to: target_offset,
            timing_function: :ease,
            on_progression: ->(progress){@scroll_offset = progress; self.apply_constraints},
            on_finish: ->{self.apply_constraints; completion&.call}
        )
    end
    def scroll_size
        last_elem_rect = self.last_element.rectangle
        last_elem_end_pos = vertical? ? last_elem_rect.bottom : last_elem_rect.right
        this_end_pos = vertical? ? @rectangle.bottom : @rectangle.right
        (@scroll_offset + last_elem_end_pos - this_end_pos).clamp(0...)
    end
    def vertical?
        true
    end
    def horizontal? #do not override this one!
        !vertical?
    end
    def scroll_buttons?
        true
    end
    def last_element
        sub_elems_to_use = @sub_elements.reject{|name, val| @no_scroll_elements.include?(name)}
        sub_elements_to_compare = sub_elems_to_use.map{|k,el| all_sub_elements(el)}.flatten!
        return sub_elements_to_compare.max{|a,b| a.rectangle.bottom <=> b.rectangle.bottom} if vertical?
        return sub_elements_to_compare.max{|a,b| a.rectangle.right <=> b.rectangle.right} if horizontal?
    end
    private
    def all_sub_elements(root = self)
        [root,root.sub_elements.map{|k,e| all_sub_elements(e)}]
    end
end