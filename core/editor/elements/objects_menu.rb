require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/image'
require_relative '../../ui_elements/drawables/text'
require_relative '../../game_objects/game_objects'
require_relative '../../robert'
require_relative '../../config'
class ObjectsMenu < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)      
        @sub_elements[:list] = List.new(@root, ListObjectElement, direction: :vertical)
        .constrain{@scrl_rect}
        objects_to_show = [
            GameObjects::Bush,
            GameObjects::Wall,
            GameObjects::Apple,
            GameObjects::PineCone,
            Robert
        ]
        @sub_elements[:list].data = objects_to_show.map{|obj| {object: obj, selected: false}}
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
        DEFAULT_ICON = File.join(Config::ASSETS_DIR, 'nothing_64x.png')
        UNSELECTED_BG_COLOR = Gosu::Color::NONE
        SELECTED_BG_COLOR = Gosu::Color::rgba(64,64,255,128)
        def build
            self.background_color = UNSELECTED_BG_COLOR
            @sub_elements[:icon] = Image.new(@root, DEFAULT_ICON){@rectangle.relative_to(y: PADDING_TOP).assign!(height: ICON_SIZE)}
            text_top_offset = PADDING_TOP + ICON_SIZE + LOGO_SEPARATION 
            @sub_elements[:name] = Text.new(@root, "...", font_size: FONT_SIZE){@rectangle.relative_to(y: text_top_offset, height: -text_top_offset)}
            self.add_event(:click){@root.select_object(@data[:object])}
        end
        def list_constraint parent_rect
            parent_rect.assign(y:0, height: HEIGHT)
        end
        def update_data object:, selected:
            icon_path = File.join(Config::ASSETS_DIR, object.default_texture)
            icon_path = DEFAULT_ICON unless File.exists? icon_path
            @sub_elements[:icon].source = icon_path
            @sub_elements[:name].string = object.pretty_s
            self.background_color = selected ? SELECTED_BG_COLOR : UNSELECTED_BG_COLOR
        end
    end
end