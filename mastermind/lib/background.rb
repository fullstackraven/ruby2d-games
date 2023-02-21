# Background falling squares affect.
# Store square objects, and a random number of square objects are generated and stored in the array.

require 'ruby2d'

class Background
    attr_accessor :squares, :x_speed, :y_speed, :num_squares

  def initialize
    @squares = []
    @x_speed = 0
    @y_speed = 0
    @num_squares = rand(500..1000)
  end

  def random_squares
    @num_squares.times do
    x = rand(0..Window.width)
    y = rand(-9999..Window.height)
    @squares << Square.new(x: x, y: y, size: 25, color: 'gray', opacity: rand(0.01..0.5), z: -9999)
    end
  end

  def populate_squares
    @squares.each do |square|
        square.y += rand(0.01..1)
        square.add
        square.x += @x_speed
        square.y += @y_speed
    end
  end

  def squares_left
    @x_speed = -2
    @y_speed = 0
  end

  def squares_right
    @x_speed = 2
    @y_speed = 0
  end

  def squares_up
    @x_speed = 0
    @y_speed = -2
  end 

  def squares_down
    @x_speed = 0
    @y_speed = 2
  end
end