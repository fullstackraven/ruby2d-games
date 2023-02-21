require 'ruby2d'

class BallTrajectory
  def initialize(ball)
    @ball = ball
  end

  def draw
    next_coordinates = NextCoordinates.new(@ball.x_middle, @ball.y_middle, @ball.x_velocity, @ball.y_velocity)
    line = Line.new(x1: @ball.x_middle, y1: @ball.y_middle, x2: next_coordinates.x, y2: next_coordinates.y,
                    color: 'red', opacity: 0)
    if next_coordinates.hit_top_or_bottom?
      final_coordinates = NextCoordinates.new(next_coordinates.x, next_coordinates.y, @ball.x_velocity,
                                              -@ball.y_velocity)
      Line.new(x1: next_coordinates.x, y1: next_coordinates.y, x2: final_coordinates.x, y2: final_coordinates.y,
               color: 'red', opacity: 0)
    else
      line
    end
  end

  def y_middle
    draw.y2
  end
end
