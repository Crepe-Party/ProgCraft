require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/image'
require_relative '../../ui_elements/drawables/text'
class ObjectsMenu < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)      
        @sub_elements[:list] = List.new(@game, ListObjectElement, direction: :vertical){Rectangle2.new(@scrl_rect.x, @scrl_rect.y, @scrl_rect.width, 0)}
        #preload
        @sub_elements[:list].data = 5.times.map{{name: '...', type: nil}}
        #fake load with test data
        @game.plan_action(0.5) do
            @sub_elements[:list].data = [
                {name: "Bush", type: "bush"},
                {name: "Wall", type: "wall"}
            ]
        end
        super
    end
    def vertical?
        true
    end

    #list class
    class ListObjectElement < UIElement 
        include Listable

        PADDING_TOP = 20
        ICON_SIZE = 128
        LOGO_SEPARATION = 10
        FONT_SIZE = 30
        HEIGHT = PADDING_TOP + 2*LOGO_SEPARATION + ICON_SIZE + FONT_SIZE
        DEFAULT_ICON = File.join(File.dirname(__FILE__), '../../assets/editor_objects/nothing_128x.png')
        def build
            @sub_elements[:icon] = Image.new(@game, DEFAULT_ICON){Rectangle2.new(@rectangle.x + (@rectangle.width - ICON_SIZE) / 2, @rectangle.y + PADDING_TOP, @rectangle.width, ICON_SIZE)}
            text_top_offset = PADDING_TOP + ICON_SIZE + LOGO_SEPARATION 
            @sub_elements[:name] = Text.new(@game, "Test text", font_size: FONT_SIZE){Rectangle2.new(@rectangle.x, @rectangle.y + text_top_offset, @rectangle.width, @rectangle.height - text_top_offset)}
        end
        def list_constraint parent_rect
            Rectangle2.new(parent_rect.x,0,parent_rect.width, HEIGHT)
        end
        def update_data data
            # pp "update_data", data
            icon_path = File.join(File.dirname(__FILE__), "../../assets/editor_objects/#{data[:type]}_128x.png")
            icon_path = DEFAULT_ICON unless File.exists? icon_path
            @sub_elements[:icon].source = icon_path
            @sub_elements[:name].string = data[:name]
        end
    end
end