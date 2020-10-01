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
        @sub_elements[:before_button] = Button.new(@game, vertical? ? "▲" : "◄"){
            next Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.y + 5, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE) if vertical?
            next Rectangle2.new(@rectangle.x + 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
        }
        @sub_elements[:after_button] = Button.new(@game, vertical? ? "▼" : "►"){
            Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
        }
        setup_scroll_events
    end
    def apply_constraints
        return unless @game.ready_for_constraints
        @rectangle.assign(@constraint.call) if @constraint
        @scrl_rect = @rectangle.clone
        @scrl_rect.x += @scroll_offset unless vertical?
        @scrl_rect.y += @scroll_offset if vertical?
        super
    end
    def setup_scroll_events
        add_event(:mouse_up, {button: Gosu::MS_WHEEL_DOWN}){ self.scroll_offset-=SCROLL_FACTOR }
        add_event(:mouse_up, {button: Gosu::MS_WHEEL_UP}){ self.scroll_offset+=SCROLL_FACTOR }
        @sub_elements[:after_button].add_event(:mouse_down, {button: Gosu::MS_LEFT}){ self.scroll_offset-=SCROLL_FACTOR }
        @sub_elements[:before_button].add_event(:mouse_down, {button: Gosu::MS_LEFT}){ self.scroll_offset+=SCROLL_FACTOR }
    end
    def scroll_offset= scroll_offset
        @scroll_offset = scroll_offset
        apply_constraints
    end
    def vertical?
        true
    end
end