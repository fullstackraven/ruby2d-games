require 'ruby2d'

class DisplayImages 
  attr_accessor :start_game, :start_game_clicked, :logo, :rules, :clues, :maker, :master_code_set, :turn

  HUMAN_TURN_MAP = [
    'turn_1',
    'turn_2'
  ]

  def initialize
    # Add images to window
    @start_game = create_image('img/start_game.png', 5, -9999, 900, 400, 1)
    @start_game_clicked = create_image('img/start_game_click.png', 5, -9999, 900, 400, 1)
    @logo = create_image('img/mastermind_logo.png', 200, -9999, 500, 200, 10)
    @rules = create_image('img/rules.png', 10, -9999, 950, 900, 10)
    @clues = create_image('img/clues.png', 10, -9999, 950, 900, 1)
    @maker = create_image('img/maker.png', 20, -9999, 950, 900, 10)
    @master_code_set = create_image('img/master_code_set.png', 200, -9999, 500, 200, 1)
    @turn = turn_images(100, -9999, 450, 100, 1)
  end

  # Method to handle image creation on Window
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

  def turn_images(x, y, w, h, z)
    turn_number = HUMAN_TURN_MAP[0]
    human_turn = Image.new(
      "img/#{turn_number}.png",
      x: x,
      y: y,
      width: w,
      height: h,
      z: z
    )
    return human_turn
  end
end