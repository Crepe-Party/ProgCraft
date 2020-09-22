require_relative '../ui_element'
require_relative 'button'
class Scrollable < UIElement
    attr_reader :scroll_offset
    SCROLL_BUTTONS_SIZE = 30
    def build
        @scroll_offset = 0
        @sub_elements[:before_button] = Button.new(@game, vertical? ? "▲" : "◄"){
            next Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.y + 5, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE) if vertical?
            next Rectangle2.new(@rectangle.x + 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
        }
        @sub_elements[:after_button] = Button.new(@game, vertical? ? "▼" : "►"){
            Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
        }
        super
    end
    def apply_constraints
        @rectangle = @constraint.call if @constraint
        @scrl_rect = @rectangle.clone
        @scrl_rect.x += @scroll_offset unless vertical?
        @scrl_rect.y += @scroll_offset if vertical?
        super
    end
    def scroll_offset= scroll_offset
        @scroll_offset = scroll_offset
        apply_constraints
    end
    def vertical?
        true
    end
end