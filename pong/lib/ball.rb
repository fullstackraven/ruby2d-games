require 'ruby2d'

class Ball
  HEIGHT = 20

  attr_reader :shape, :x_velocity, :y_velocity
  attr_accessor :speed, :y

  def initialize(speed)
    @x = 320
    @y = rand(100..400)
    @speed = speed
    @y_velocity = speed
    @x_velocity = [-speed, speed].sample
  end

  def move
    if hit_bottom? || hit_top?
      @y_velocity = -@y_velocity
    end

    @x = @x + @x_velocity
    @y = @y + @y_velocity
  end

  def draw
    @shape = Square.new(x: @x, y: @y, size: HEIGHT, color: 'white')
  end

  def bounce_off(paddle)
    if @last_hit_side != paddle.side
      position = ((@shape.y1 - paddle.y1) / Paddle::HEIGHT.to_f)
      angle = position.clamp(0.2, 0.8) * Math::PI

      if paddle.side == :left
          @x_velocity = Math.sin(angle) * @speed
          @y_velocity = -Math.cos(angle) * @speed
      else
          @x_velocity = -Math.sin(angle) * @speed
          @y_velocity = -Math.cos(angle) * @speed
      end

      @last_hit_side = paddle.side
    end
  end

  def y_middle
    @y + (HEIGHT / 2)
  end

  def x_middle
    @x + (HEIGHT / 2)
  end

  def out_of_bounds_left?
    @x <= 0
  end

  def out_of_bounds_right?
    @shape.x2 >= Window.width
  end

  private

  def hit_bottom?
    @y + HEIGHT >= Window.height
  end

  def hit_top?
    @y <= 0
  end
end
