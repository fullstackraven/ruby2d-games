require 'ruby2d'

class Display
  attr_accessor :board, :save, :start_page

  def initialize
    @start_page = create_image('img/hangman_start_page.png', 0, 0, Window.width, Window.height, 10)
    @board = create_image('img/hangman_board.png', 0, 0, Window.width, Window.height, 1)
    @save = create_image('img/save_and_exit.png', 0, -999, Window.width, Window.height, 10)
    @back = create_image('img/back_button.png', 0, 20, 250, 250, 1)
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
end
