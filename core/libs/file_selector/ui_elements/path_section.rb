require_relative '../../../ui_elements/widgets/scrollable'
require_relative '../../../ui_elements/widgets/list'
require_relative '../../../ui_elements/drawables/text'
module FileSelectorUI
    class PathSection < Scrollable
        PATH_LIST_HEIGHT = 20
        def build
            @sub_elements[:list] = List.new(@root, PathElement, direction: :horizontal, parent_element: self){@rectangle.assign(height: PATH_LIST_HEIGHT)}
            @sub_elements[:list].data = temp_on_change_path "c:/tools/ProgCraft" #TODO: no
            super
        end
        def vertical?
            false
        end
        def scroll_buttons?
            false
        end
        def temp_on_change_path path
            splitted_path = path.split("/")
            newdata = splitted_path.length.times.map do |index|
                splitted_path.slice(0, index + 1).join("/")
            end
            pp "newdata=", newdata
            newdata
            # @sub_elements[:list].data = newdata #TODO: doesn't fockin work
        end
    end
    class PathElement < UIElement
        TEXT_MARGIN = 10
        include Listable
        def build
            @sub_elements[:button] = Button.new(@root, "..."){@rectangle}
            #event
            @sub_elements[:button].on_click do
                puts "click for: #{@target_path}"
                @parent_list.parent_element.temp_on_change_path @target_path
            end
        end
        def update_data data
            @target_path = data
            @sub_elements[:button].text = data.split('/').last
        end
        def list_constraint parent_rect
            width = @sub_elements[:button].text_elem.font.text_width(@sub_elements[:button].text)
            Rectangle2.new(0,0,width, parent_rect.height)
        end
    end
end