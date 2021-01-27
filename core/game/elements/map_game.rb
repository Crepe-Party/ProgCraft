require_relative '../../ui_elements/widgets/grid_game_container'
require_relative './whats_arbre'
require_relative './inventory'
class MapGameDisplay < GridGameContainer
    attr_reader :whats_arbre_open
    WA_MARGIN = 20
    WA_BTN_SIZE = 80
    WA_WIDTH = 400
    INVENTORY_HEIGHT = 100
    def build
        @whats_arbre_open = false
        @whats_arbre_top_fraction = 1
        self.background_color = Gosu::Color::rgba(0,128,0,255)
        super
        @sub_elements[:whats_arbre] = WhatsArbre.new(@root, parent_element: self).constrain do 
            top_pos = @whats_arbre_top_fraction * (@rectangle.height - WA_MARGIN)
            @rectangle.relative_to(x: @rectangle.width - WA_WIDTH - WA_MARGIN, y: WA_MARGIN + top_pos, height: - 3 * WA_MARGIN - WA_BTN_SIZE).assign!(width: WA_WIDTH)
        end
        @sub_elements[:whats_arbre_button] = Button.new(@root, background_image: 'icons/whatsapp_tree_64x.png', bg_color: Gosu::Color::rgba(255, 255, 255, 128))
            .constrain{ Rectangle2.new(@rectangle.right - WA_BTN_SIZE - WA_MARGIN, @rectangle.bottom - WA_BTN_SIZE - WA_MARGIN, WA_BTN_SIZE, WA_BTN_SIZE) }
            .on_click{ self.whats_arbre_open ^= true }
        @sub_elements[:inventory_display] = InventoryDisplay.new(@root)
            .constrain{@rectangle.relative_to(x:10, width: -WA_WIDTH-2*WA_MARGIN).assign!(height:INVENTORY_HEIGHT, y: @rectangle.bottom - (INVENTORY_HEIGHT * (@inventory_visibility_fraction || 0)))}
    end
    def whats_arbre_open= is_open
        return is_open if @whats_arbre_open == is_open
        @whats_arbre_open = is_open
        if (is_open)
            @sub_elements[:whats_arbre][:text_input].focus
        else
            @sub_elements[:whats_arbre][:text_input].unplug
        end
        #animate
        @current_open_animation.cancel if @current_open_animation
        @current_open_animation = @root.animate(0.5, from: @whats_arbre_top_fraction, to:(is_open ? 0 : 1), timing_function: :ease) do |progression|
            @whats_arbre_top_fraction = progression
            @sub_elements[:whats_arbre].apply_constraints
        end
    end
    def update_inventory
        return unless @root.robert
        @root.plan_action do 
            inventory_data = @root.robert.inventory.group_by{|go|{type:go.class, name:go.name}}.map{|id,objs| {type: id[:type], name: id[:name], count: objs.count}}
            @sub_elements[:inventory_display][:list].data = inventory_data
            has_items = inventory_data.empty?
            next if has_items ==  @inventory_visible
            @inventory_visible = has_items
            #animate
            @root.animate(0.5, from: (@inventory_visibility_fraction || 0), to: @inventory_visible?0:1, timing_function: :ease) do |progression| 
                @inventory_visibility_fraction = progression
                @sub_elements[:inventory_display].apply_constraints
            end
        end
    end
end