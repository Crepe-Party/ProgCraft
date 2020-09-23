require 'ruby2d'

set title: "ProgCraft Level Creator"
set background: '#6666ff'
set resizable: true

bg = Image.new(
  'sprites/Sunset.jpg',
  x: 0, y: 0,
  width: Window.viewport_width,
  height: Window.viewport_height
)
tri = Triangle.new(
    x1: 50, y1: 50,
    x2: 100, y2: 20,
    x3: 100, y3: 200
)


coin = Sprite.new(
  'sprites/coin.png',
  x: 100,
  y: 100,
  clip_width: 84,
  time: 100,
  loop: true
)
coin.play

lastFrameTime = Time.now
update do
  #delta
  delta = 1.0 / (get :fps)
  puts delta
  #window
  if(Window.height != Window.viewport_height || Window.width != Window.viewport_width)
    puts "wow"
    set viewport_height: Window.height
    set viewport_width: Window.width
  end
end

show