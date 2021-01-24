require_relative '../ui_element'
require_relative 'button'
class Scrollable < UIElement
    attr_reader :scroll_offset
    SCROLL_UI_SIZE = 30
    MIN_SCROLLBAR_SIZE = 120
    MOUSE_SCROLL_FACTOR = 30
    BUTTON_SCROLL_FACTOR = 100
    def setup
        @no_scroll_elements = [:scroll_bar, :before_button, :after_button, :background_color] #if some elements don't scroll, add them in this list
    end
    def build
        #please call super() at the end of your build method to prevent sketchy behaviors with buttons
        @scrl_rect = Rectangle2.new
        @overflow = :hidden
        @scroll_offset = 0
        if scroll_ui?
            @sub_elements[:scroll_bar] = Button.new(@root, bg_color: Gosu::Color::rgba(255,255,255,64), bg_color_hover: Gosu::Color::rgba(255,255,255,192))
            .constrain do |sb|
                scrl_size = self.scroll_size
                rect_size = vertical? ? @rectangle.height : @rectangle.width
                bar_zone_size = (rect_size - 2 * (SCROLL_UI_SIZE + 10)).clamp(0..)
                sb_size = MIN_SCROLLBAR_SIZE.clamp(0..(bar_zone_size / 2)).clamp((bar_zone_size - scrl_size)..)
                available_size = (bar_zone_size - sb_size).clamp(1..)
                scroll_fraction = (scrl_size <= 0) ? 0 : (self.scroll_offset / scrl_size.to_f)
                sb_position = scroll_fraction * available_size + SCROLL_UI_SIZE + 10
                @sb_scroll_factor = scrl_size / available_size
                next @rectangle.assign(x: @rectangle.right - SCROLL_UI_SIZE - 5, width: SCROLL_UI_SIZE, height: sb_size).relative_to!(y: sb_position) if vertical?
                next @rectangle.assign(y: @rectangle.bottom - SCROLL_UI_SIZE - 5, height: SCROLL_UI_SIZE, width: sb_size).relative_to!(x: sb_position)
            end
            .add_event(:mouse_drag, button: Gosu::MS_LEFT) do |evt|
                pos_diff = vertical? ? evt[:position_diff].y : evt[scrl_size:position_diff].x
                scaled_diff = pos_diff * (@sb_scroll_factor || 1)
                self.scroll_offset += scaled_diff
            end

            @sub_elements[:before_button] = Button.new(@root, vertical? ? "▲" : "◄")
            .constrain do
                next Rectangle2.new(@rectangle.right - SCROLL_UI_SIZE - 5, @rectangle.y + 5, SCROLL_UI_SIZE, SCROLL_UI_SIZE) if vertical?
                next Rectangle2.new(@rectangle.x + 5, @rectangle.bottom - 5 - SCROLL_UI_SIZE, SCROLL_UI_SIZE, SCROLL_UI_SIZE)
            end
            .on_click{ self.scroll_to(self.scroll_offset - BUTTON_SCROLL_FACTOR, 0.1) }

            @sub_elements[:after_button] = Button.new(@root, vertical? ? "▼" : "►")
            .constrain{ Rectangle2.new(@rectangle.right - SCROLL_UI_SIZE - 5, @rectangle.bottom - 5 - SCROLL_UI_SIZE, SCROLL_UI_SIZE, SCROLL_UI_SIZE)}
            .on_click{ self.scroll_to(self.scroll_offset + BUTTON_SCROLL_FACTOR, 0.1)}
        end
        #scroll events
        add_event(:mouse_down, { button: Gosu::MS_WHEEL_DOWN }){ self.scroll_offset+=MOUSE_SCROLL_FACTOR; }
        add_event(:mouse_down, { button: Gosu::MS_WHEEL_UP }){ self.scroll_offset-=MOUSE_SCROLL_FACTOR; }
    end
    def apply_constraints
        return unless @root.ready_for_constraints
        @rectangle.assign!(@constraint.call(self)) if @constraint
        @scrl_rect = @rectangle.clone
        @scrl_rect.y -= @scroll_offset if vertical?
        @scrl_rect.x -= @scroll_offset if horizontal?
        @scrl_rect.height = 0 #to prevent circular height references messing with scroll limit
        scroll_to(@scroll_offset, 0, skip_constraints: true) #reposition in case of scroll overflow
        super
    end
    
    def scroll_offset= scroll_offset #number or :end
        scroll_to(scroll_offset, 0)
    end
    def scroll_to(position, animation_length=0.2, skip_constraints: false, &completion)
        @current_scroll_animation&.cancel unless skip_constraints
        
        target_offset = (position == :end) ? self.scroll_size : position.clamp(0, self.scroll_size)
        if(animation_length == 0)
            @scroll_offset = target_offset
            unless skip_constraints
                self.apply_constraints
                self.apply_constraints #a second time because of some rendering logic issue with line breaks and lists
            end
            completion&.call
            return
        end
        @current_scroll_animation = @root.animate(
            animation_length, 
            from: @scroll_offset, 
            to: target_offset,
            timing_function: :ease,
            on_progression: ->(progress){@scroll_offset = progress; self.apply_constraints unless skip_constraints},
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
    def scroll_ui?
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