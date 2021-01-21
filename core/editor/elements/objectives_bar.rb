require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../config'
class ObjectivesBar < Scrollable
    ADD_BTN_MARGIN = 20
    
    OBV_ICON_SIZE = 64
    OBV_FONT_SIZE = 20
    OBV_TXT_SCT_HEIGHT = 40
    OBV_DEFAULT_ICON = File.join(Config::ASSETS_DIR, 'objectives/nothing_64x.png')
    def build
        self.background_color = Gosu::Color.rgba(50,50,50,255)
        #list
        @sub_elements[:list] = List.new(@root, ObjectiveAdapter, direction: :horizontal, spacing: 10)
        .constrain{@scrl_rect}
        
        # @root.plan_action :next_frame do
            @sub_elements[:list].data = 10.times.map{{name: '...', type: nil}}#preload
        # end

        def on_data_get data
            @sub_elements[:list].data = data
            #btn
            @sub_elements[:add_btn] = Button.new(@root, "+").constrain do
                list_rect = @sub_elements[:list].rectangle
                # puts "list_rect #{list_rect.width}"
                Rectangle2.new(list_rect.right + ADD_BTN_MARGIN, @scrl_rect.y + ADD_BTN_MARGIN, @scrl_rect.height - 2*ADD_BTN_MARGIN, @scrl_rect.height - 2*ADD_BTN_MARGIN)
            end
            self.apply_constraints #a bit too hardcoded :/
        end

        # fake load with test data
        @root.plan_action 1 do
            on_data_get [
                {type: 'use_item', name: 'Chop a tree'},
                {type: 'have_item', name: 'Pick up a log'},
                {type: 'location', name: 'Go into the house'},
            ] 
        end
        super
    end
    def vertical?
        false
    end

    class ObjectiveAdapter < UIElement
        include Listable
        
        def build
            @sub_elements[:icon] = Image.new(@root, OBV_DEFAULT_ICON){Rectangle2.new(@rectangle.x + (@rectangle.width - OBV_ICON_SIZE) / 2, @rectangle.y + (@rectangle.height - OBV_TXT_SCT_HEIGHT - OBV_ICON_SIZE)/2, OBV_ICON_SIZE, OBV_ICON_SIZE)}
            @sub_elements[:name] = Text.new(@root, "Test text", font_size: OBV_FONT_SIZE, color: Gosu::Color::WHITE){Rectangle2.new(@rectangle.x, @rectangle.bottom - OBV_TXT_SCT_HEIGHT, @rectangle.width, OBV_TXT_SCT_HEIGHT)}
        end
        def update_data data
            icon_path = File.join(Config::ASSETS_DIR, "objectives/#{data[:type]}_64x.png")
            icon_path = OBV_DEFAULT_ICON unless File.exists? icon_path
            @sub_elements[:icon].source = icon_path
            @sub_elements[:name].string = data[:name]
        end
        def list_constraint parent_rect
            size = parent_rect.height - 2*@parent_list.spacing
            Rectangle2.new(0, parent_rect.y + @parent_list.spacing, size, size)
        end
    end
end