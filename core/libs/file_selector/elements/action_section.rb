require_relative '../../../ui_elements/widgets/scrollable'
require_relative '../../../ui_elements/widgets/list'
require_relative '../../../ui_elements/widgets/button'
module FileSelectorUI
    class ActionSection < Scrollable
        def build
            super
            @sub_elements[:list] = List.new(@root, ActionButton, direction: :horizontal, spacing: 10, start_offset: 10){@rectangle}
            self.favorites_data = []
        end
        def favorites_data= data
            @sub_elements[:list].data = [
                {type: :button, image: 'parent_dir.png', action: :parent_dir},
                {type: :button, image: 'hard_drive.png', action: :root_dir},
                {type: :button, image: 'edit_text.png', action: :edit_path}
            ] + data
        end
        def scroll_buttons?
            false
        end
        def vertical?
            false
        end
    end
    class ActionButton < Button
        include Listable
        def build
            super
        end
        def update_data type: nil, image: nil, action: nil
            self.text = "aaa"
        end
        def list_constraint parent_rect
            Rectangle2.new.assign!(width:200, height: parent_rect.height)
        end
    end
end