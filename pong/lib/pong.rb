# Imports
require 'ruby2d'
require_relative 'ball_trajectory.rb'
require_relative 'ball.rb'
require_relative 'display.rb'
require_relative 'dividing_line.rb'
require_relative 'next_coordinates.rb'
require_relative 'paddle.rb'

# Set up the window
set title: 'PONG',
    resizable: true,
    background: 'black'

# Initialize game state
ball_velocity = 1
last_hit_frame = 0
player_score = 0
opponent_score = 0
single_player = false
multi_player = false
paused = false
game_reset = false
level_selected = false
display_pause = []

# Create game objects
player = Paddle.new(:left, 8)
player2 = Paddle.new(:right, 8)
computer = Paddle.new(:right, 5)
ball = Ball.new(ball_velocity)
ball_trajectory = BallTrajectory.new(ball)
divider = DividingLine.new

# Handle mouse clicks for mode selector
on :mouse_down do |event|
  single_player = event.x > 160 && event.x < 480 && event.y > 205 && event.y < 260 ? true : single_player
  multi_player = event.x > 160 && event.x < 480 && event.y > 305 && event.y < 360 ? true : multi_player
end

# Handle keyboard input
on :key_down do |event|
  # Single player mode
  if single_player
    case event.key
    when 'e'
      computer.movement_speed = 2
      ball_velocity = 5
      ball = Ball.new(ball_velocity)
      ball_trajectory = BallTrajectory.new(ball)
      level_selected = true
    when 'm'
      computer.movement_speed = 5
      ball_velocity = 10
      ball = Ball.new(ball_velocity)
      ball_trajectory = BallTrajectory.new(ball) 
      level_selected = true
    when 'h'
      computer.movement_speed = 10
      ball_velocity = 15
      ball = Ball.new(ball_velocity)
      ball_trajectory = BallTrajectory.new(ball)
      level_selected = true
    end
  end
  # Multi player mode
  if multi_player
    case event.key
    when 's'
      ball_velocity = 5
      ball = Ball.new(ball_velocity)
      ball_trajectory = BallTrajectory.new(ball)
      level_selected = true
    when 'm'
      ball_velocity = 10
      ball = Ball.new(ball_velocity)
      ball_trajectory = BallTrajectory.new(ball)
      level_selected = true
    when 'f'
      ball_velocity = 20
      ball = Ball.new(ball_velocity)
      ball_trajectory = BallTrajectory.new(ball)
      level_selected = true
    end
  end
  # Reset game
  if event.key == 'escape'
    last_hit_frame = 0
    player_score = 0
    opponent_score = 0
    single_player = false
    multi_player = false
    level_selected = false
    player = Paddle.new(:left, 8)
    player2 = Paddle.new(:right, 8)
    computer = Paddle.new(:right, 5)
    divider = DividingLine.new
    paused = false
  end
  # Restart game
  if event.key == 'r'
    last_hit_frame = 0
    player_score = 0
    opponent_score = 0
    ball = Ball.new(ball_velocity)
    ball_trajectory = BallTrajectory.new(ball)
    paused = false
    game_reset = true
  end
  # Pause game
  pause_image = Image.new('img/paused.png', x: 0, y: 0, width: Window.width, height: Window.height, z: 1)
  if event.key == 'space'
    paused = !paused
    display_pause << event.key
    if display_pause.length.odd?
      pause_image.add
    elsif display_pause.length.even?
      pause_image.remove
    end
  end
end

# Built-in method to handle looping game-play
update do
  unless paused
    clear

    display = Display.new(player_score, opponent_score)

    if single_player
      display.start.remove
      if level_selected
        display.level.remove
        display.speed.y = -999
        divider.draw
        display.score_left.add
        display.score_right.add

        if player.hit_ball?(ball)
          ball.bounce_off(player)
          last_hit_frame = Window.frames
        end

        if computer.hit_ball?(ball)
          ball.bounce_off(computer)
          last_hit_frame = Window.frames
        end

        player.move
        player.draw

        ball.move
        ball.draw

        ball_trajectory.draw

        computer.track_ball(ball_trajectory, last_hit_frame)
        computer.draw

        if ball.out_of_bounds_left?
          opponent_score += 1
          ball = Ball.new(ball_velocity)
          ball_trajectory = BallTrajectory.new(ball)
        elsif ball.out_of_bounds_right?
          player_score += 1
          ball = Ball.new(ball_velocity)
          ball_trajectory = BallTrajectory.new(ball)
        end
      end
    end

    if multi_player
      display.start.remove
      display.level.y = -999
      if level_selected
        display.speed.remove
        divider.draw
        display.score_left.add
        display.score_right.add

        if player.hit_ball?(ball)
          ball.bounce_off(player)
          last_hit_frame = Window.frames
        end

        if player2.hit_ball?(ball)
          ball.bounce_off(player2)
          last_hit_frame = Window.frames
        end

        player.move
        player.draw

        ball.move
        ball.draw

        ball_trajectory.draw

        player2.move
        player2.draw

        if ball.out_of_bounds_left?
          opponent_score += 1
          ball = Ball.new(ball_velocity)
          ball_trajectory = BallTrajectory.new(ball)
        elsif ball.out_of_bounds_right?
          player_score += 1
          ball = Ball.new(ball_velocity)
          ball_trajectory = BallTrajectory.new(ball)
        end
      end
    end

    if player_score == 10
      display.win.x = 0
      display.win.y = 50
    elsif opponent_score == 10
      display.win.x = 270
      display.win.y = 50
    end

    if player_score == 10 || opponent_score == 10
      paused = true
      game_reset = false
    end

    if game_reset
      display.win.remove
    end
  end
end

# Handles players movements - dynamic
on :key_held do |event|
  if single_player
    if event.key == 'up'
      player.y_movement = -1
    elsif event.key == 'down'
      player.y_movement = 1
    end
  end
  if multi_player
    if event.key == 'q'
      player.y_movement = -1
    elsif event.key == 'a'
      player.y_movement = 1
    elsif event.key == 'p'
      player2.y_movement = -1
    elsif event.key == 'l'
      player2.y_movement = 1
    end
  end
end

# Handles players movements - static
on :key_up do |event|
  if single_player
    player.y_movement = 0
  elsif multi_player
    player.y_movement = 0
    player2.y_movement = 0
  end
end

show
