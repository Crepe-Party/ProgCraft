require_relative '../../ui_elements/widgets/scrollable'
require_relative '../../ui_elements/widgets/list'
require_relative '../../ui_elements/widgets/button'
require_relative '../../ui_elements/drawables/image'
require_relative '../../ui_elements/drawables/text'
class ObjectsMenu < Scrollable
    def build
        self.background_color = Gosu::Color.rgba(100,100,100,255)
        # 10.times do |ind|
        #     @sub_elements["test_elem_#{ind}".to_sym] = Button.new(@game, "Testeuh #{ind}"){Rectangle2.new(@scrl_rect.x, @scrl_rect.y + 100*ind, @scrl_rect.width, 100)}
        # end
        data = [
            {name: "Bush", image: "basic_bush.png"},
            {name: "Wall", image: "wall.png"}
        ]
        data.each_with_index do |datum, ind|
            @sub_elements["test_elem_#{ind}".to_sym] = HardCodedObjectElement.new(@game, datum){Rectangle2.new(@scrl_rect.x, @scrl_rect.y + 150*ind, @scrl_rect.width, 150)}
        end

        @sub_elements[:list] = List.new(@game, ListObjectElement, direction: :vertical)
        super
        # @sub_elements[:list].data = [
        #     {name: "Bush"},
        #     {name: "Axe"}
        # ]
    end
    def vertical?
        true
    end

    #list class
    class ListObjectElement < UIElement
        include Listable
        PADDING_TOP = 20
        LOGO_SEPARATION = 10
        ICON_SIZE = 100
        def build
            icon_path = File.join(File.dirname(__FILE__), '../../assets/basic_bush.png')
            @sub_elements[:object_icon] = Image.new(@game, icon_path){Rectangle2.new(@rectangle.x + (@rectangle.width - ICON_SIZE) / 2, @rectangle.y + PADDING_TOP, @rectangle.width, ICON_SIZE)}
            text_top_offset = PADDING_TOP + ICON_SIZE + LOGO_SEPARATION 
            @sub_elements[:name] = Text.new(@game, "Test text"){Rectangle2.new(@rectangle.x, @rectangle.y + text_top_offset, @rectangle.width, @rectangle.height - text_top_offset)}
        end
        def data= data
            puts "new data #{data}"
            @sub_elements[:name].string = data[:name]
        end
        def base_rect
            Rectangle2.new(0,0, 100, 200)
        end
    end

    class HardCodedObjectElement < UIElement
        PADDING_TOP = 20
        LOGO_SEPARATION = 10
        ICON_SIZE = 100
        def initialize game, data, &constraint
            @data = data
            super game, &constraint
        end
        def build
            icon_path = File.join(File.dirname(__FILE__), "../../assets/#{@data[:image]}")
            @sub_elements[:object_icon] = Image.new(@game, icon_path){Rectangle2.new(@rectangle.x + (@rectangle.width - ICON_SIZE) / 2, @rectangle.y + PADDING_TOP, @rectangle.width, ICON_SIZE)}
            text_top_offset = PADDING_TOP + ICON_SIZE + LOGO_SEPARATION 
            @sub_elements[:name] = Text.new(@game, @data[:name]){Rectangle2.new(@rectangle.x, @rectangle.y + text_top_offset, @rectangle.width, @rectangle.height - text_top_offset)}
        end
    end
end