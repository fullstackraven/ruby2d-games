require 'ruby2d'

class Display
  attr_accessor :start, :level, :speed, :win, :paused, :score_left, :score_right

  def initialize(player_score, opponent_score)
    @start = create_image('img/pong_start.png', 0, 0, Window.width, Window.height, 1)
    @level = create_image('img/level.png', 0, 0, Window.width, Window.height, -1)
    @speed = create_image('img/speed.png', 0, 0, Window.width, Window.height, -2)
    @win = create_image('img/win.png', -30, -999, 400, 400, 10)
    @score_left = create_text("#{player_score}", 230, 5, 50, 'bold', 'white')
    @score_right = create_text("#{opponent_score}", 400, 5, 50, 'bold', 'white')
  end

  def create_image(img_file, x, y, w, h, z)
    image = Image.new(
      img_file,
      x: x,
      y: y,
      width: w,
      height: h,
      z: z
    )
    return image
  end

  def create_text(input_text, x, y, size, style, color)
    text = Text.new(
      input_text,
      x: x,
      y: y,
      size: size,
      style: style,
      color: color
    )
    return text
  end
end
