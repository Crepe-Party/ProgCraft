class InventoryDisplay < UIElement
    TITLE_SIZE = 20
    def build
        @sub_elements[:title] = Text.new(@root, "Inventory", center_text: false, font_size: TITLE_SIZE){@rectangle.assign(height: TITLE_SIZE)}
        @sub_elements[:list] = List.new(@root, InventoryElement, direction: :horizontal){@rectangle.relative_to(y: TITLE_SIZE, height: -TITLE_SIZE-10)}
        @sub_elements[:list].background_color = Gosu::Color::rgba(64,64,64,128)
    end
    class InventoryElement < UIElement
        include Listable
        DEFAULT_ICON = File.join(Config::ASSETS_DIR, 'nothing_64x.png')
        def build
            @sub_elements[:icon] = Image.new(@root, DEFAULT_ICON){@rectangle}
            @sub_elements[:count_bg] = Rectangle.new(@root){Rectangle2.new(@rectangle.right - 25, @rectangle.bottom - 25, 20, 20)}
            @sub_elements[:count] = Text.new(@root, color: Gosu::Color::WHITE){@sub_elements[:count_bg].rectangle.relative_to(y:3)}
        end
        def list_constraint parent_rect
            parent_rect.assign(width:parent_rect.height)
        end
        def update_data type:, name: type.pretty_s, count:
            icon_path = File.join(Config::ASSETS_DIR, type.default_texture)
            icon_path = DEFAULT_ICON unless File.exists? icon_path
            @sub_elements[:icon].source = icon_path
            @sub_elements[:count].string = count.to_s
        end
    end
end