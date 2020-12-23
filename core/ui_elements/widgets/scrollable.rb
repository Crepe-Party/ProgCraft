require_relative '../ui_element'
require_relative 'button'
class Scrollable < UIElement
    attr_reader :scroll_offset
    SCROLL_BUTTONS_SIZE = 30
    SCROLL_FACTOR = 30
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
        @rectangle.assign!(@constraint.call) if @constraint
        @scrl_rect = @rectangle.clone
        @scrl_rect.x += @scroll_offset unless vertical?
        @scrl_rect.y += @scroll_offset if vertical?
        last_elem = last_element
        # p "lastrectbtm #{last_elem.rectangle.bottom}" if last_elem
        @scrl_rect.height = last_elem.rectangle.bottom - @scrl_rect.y if last_elem && vertical?
        @scrl_rect.width = last_elem.rectangle.right - @scrl_rect.x if last_elem && horizontal?
        super
    end
    def setup_scroll_events
        add_event(:mouse_up, { button: Gosu::MS_WHEEL_DOWN }){ self.scroll_offset-=SCROLL_FACTOR; :stop_propagation }
        add_event(:mouse_up, { button: Gosu::MS_WHEEL_UP }){ self.scroll_offset+=SCROLL_FACTOR; :stop_propagation }
        if scroll_buttons?
            @sub_elements[:after_button].add_event(:mouse_down, { button: Gosu::MS_LEFT }){ self.scroll_offset -= SCROLL_FACTOR }
            @sub_elements[:before_button].add_event(:mouse_down, { button: Gosu::MS_LEFT }){ self.scroll_offset += SCROLL_FACTOR }
        end
    end
    def scroll_offset= scroll_offset
        # pp @rectangle,@scrl_rect
        min_scroll = @rectangle.height - @scrl_rect.height
        # puts "minscrl #{min_scroll}"
        @scroll_offset = scroll_offset
        # @scroll_offset = scroll_offset.clamp((min_scroll <= 0)? min_scroll : 0, 0) if vertical?
        # @scroll_offset = scroll_offset.clamp(0, @scrl_rect.width) unless vertical?
        # puts @scrl_rect.height
        apply_constraints
    end
    def vertical?
        true
    end
    def horizontal?
        !vertical?
    end
    def scroll_buttons?
        true
    end
    def last_element excluding = [:before_button, :after_button, :background_color]
        sub_elems_to_use = @sub_elements.reject{ |name, val| excluding.include?(name) }
        # puts "elems to use #{sub_elems_to_use.values.length}"
        last = sub_elems_to_use.values.first
        for name, elem in sub_elems_to_use
            # puts "compare #{elem.rectangle.bottom} with #{last.rectangle.bottom}"
            last = elem if vertical? && elem.rectangle.bottom > last.rectangle.bottom
            last = elem if horizontal? && elem.rectangle.right > last.rectangle.right
        end
        last
    end
end