require_relative 'drawable'
class Image < Drawable
    attr_reader :src
    def initialize root, source= nil, cover: false, &contraint
        super root, &contraint
        self.source = source if source
        @cover = cover
    end
    def draw
        scale_y = @cover ? @rectangle.height/@image.height : 1
        scale_x = @cover ? @rectangle.width/@image.width : 1
        @image.draw(@rectangle.x + @rectangle.width/2 - @image.width*scale_x/2, @rectangle.y + @rectangle.height/2 - @image.height*scale_y/2, 0, scale_x, scale_y) if @image
    end
    def source= src
        @source = src
        @image = Gosu::Image.new src
        # pp "new image #{src}", @image
    end
end