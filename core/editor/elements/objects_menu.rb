require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/image'
require_relative '../../ui_elements/drawables/text'
require_relative '../../game_objects/game_objects'
class ObjectsMenu < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)      
        @sub_elements[:list] = List.new(@root, ListObjectElement, direction: :vertical){Rectangle2.new(@scrl_rect.x, @scrl_rect.y, @scrl_rect.width, 0)}
        @sub_elements[:list].data = [
            GameObjects::Bush,
            GameObjects::Wall,
            GameObjects::PineCone
        ]
        super
    end
    def vertical?
        true
    end

    #list class
    class ListObjectElement < UIElement 
        include Listable

        PADDING_TOP = 20
        ICON_SIZE = 64
        LOGO_SEPARATION = 10
        FONT_SIZE = 30
        HEIGHT = PADDING_TOP + 2*LOGO_SEPARATION + ICON_SIZE + FONT_SIZE
        ASSETS_PATH = '../../assets/'
        DEFAULT_ICON = File.join(File.dirname(__FILE__), ASSETS_PATH + 'nothing_64x.png')
        def build
            @sub_elements[:icon] = Image.new(@root, DEFAULT_ICON){@rectangle.relative_to(y: PADDING_TOP).assign!(height: ICON_SIZE)}
            text_top_offset = PADDING_TOP + ICON_SIZE + LOGO_SEPARATION 
            @sub_elements[:name] = Text.new(@root, "...", font_size: FONT_SIZE){@rectangle.relative_to(y: text_top_offset, height: -text_top_offset)}
        end
        def list_constraint parent_rect
            parent_rect.assign(y:0, height: HEIGHT)
        end
        def update_data data
            pp "update_data", data
            icon_path = File.join(File.dirname(__FILE__), ASSETS_PATH + data.default_texture)
            icon_path = DEFAULT_ICON unless File.exists? icon_path
            @sub_elements[:icon].source = icon_path
            @sub_elements[:name].string = data.to_s
        end
    end
end