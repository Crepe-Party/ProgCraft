require_relative '../../../ui_elements/ui_element'
module FileSelectorUI
    class MainUI < UIElement
        def build
            self.background_color = Gosu::Color::WHITE
        end
    end
end