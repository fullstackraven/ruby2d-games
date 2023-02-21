require 'ruby2d'

module Display
  def display_title
    title = Image.new(
      'img/game_logo.png',
      x: 8,
      y: -70,
      width: 500,
      height: 250
    )
  end

  def display_board
    board = Image.new(
      'img/tic-tac-toe.png',
      x: 50,
      y: 120,
      width: 400,
      height: 400
    )
  end

  def display_winner_x
    x = Image.new(
      'img/x_winner.png',
      x: 25,
      y: 225,
      width: 450,
      height: 190,
      z: 1
    )
  end

  def display_winner_o
    o = Image.new(
      'img/o_winner.png',
      x: 25,
      y: 225,
      width: 450,
      height: 190,
      z: 1
    )
  end

  def display_draw
    draw = Image.new(
      'img/draw.png',
      x: 25,
      y: 225,
      width: 450,
      height: 190,
      z: 1
    )
  end
end
