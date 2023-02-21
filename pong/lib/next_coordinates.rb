require 'ruby2d'

class NextCoordinates
  def initialize(x, y, x_velocity, y_velocity)
    @x = x
    @y = y
    @x_velocity = x_velocity
    @y_velocity = y_velocity
  end

  def x
    @x + (@x_velocity * [x_length, y_length].min)
  end

  def y
    @y + (@y_velocity * [x_length, y_length].min)
  end

  def hit_top_or_bottom?
    x_length > y_length
  end

  private

  def x_length
    if @x_velocity > 0
      (Window.width - Paddle::X_OFFSET - @x) / @x_velocity
    else
      (@x - Paddle::X_OFFSET) / -@x_velocity
    end
  end

  def y_length
    if @y_velocity > 0
      (Window.height - @y) / @y_velocity
    else
      @y / -@y_velocity
    end
  end
end
