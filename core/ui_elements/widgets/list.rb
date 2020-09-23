require_relative '../ui_element'
require_relative 'button'
class List < UIElement
    SCROLL_BUTTONS_SIZE = 30
    def build
        @sub_elements[:before_button] = Button.new(@game, vertical? ? "▲" : "◄"){
            next Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.y + 5, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE) if vertical?
            next Rectangle2.new(@rectangle.x + 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE) unless vertical? #:horizontal
            rect
        } if scrollable?
        @sub_elements[:after_button] = Button.new(@game, vertical? ? "▼" : "►"){
            next Rectangle2.new(@rectangle.right - SCROLL_BUTTONS_SIZE - 5, @rectangle.bottom - 5 - SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE, SCROLL_BUTTONS_SIZE)
        } if scrollable?
        super
    end
    def scrollable?
        true
    end
    def vertical?
        true
    end
end