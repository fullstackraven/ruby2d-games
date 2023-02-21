require 'ruby2d'

class DividingLine
    WIDTH = 10
    HEIGHT = 35
    NUMBER_OF_LINES = 10
  
    def draw
      NUMBER_OF_LINES.times do |i|
        Rectangle.new(x: Window.width / 2, y: ((Window.height + 10) / NUMBER_OF_LINES) * i, height: HEIGHT, width: WIDTH, color: 'white')
      end
    end
  end