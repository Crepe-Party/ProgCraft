require_relative '../ui_element'
class Button < UIElement
    def build
        self
        @sub_elements[:rectangle] = Rectangle.new
    end
end