# This code is written in Ruby and uses the 'ruby2d' library to create a Mastermind game.

require 'ruby2d'
require_relative 'background.rb'
require_relative 'window.rb'
require_relative 'display_images.rb'
require_relative 'display_pegs.rb'
require_relative 'human_solver.rb'

background = Background.new
background.random_squares
Mastermind.new
images = DisplayImages.new
images.start_game.y = 250
pegs = DisplayPegs.new
human_solver = HumanSolver.new

# Event handler for mouse click down on main screen button.
# Removes initial image and brings 'clicked' image onto Window.
# Creates button 'clicked' effect.
on :mouse_down do |event|
  if event.x > 270 && event.x < 640 && event.y > 530 && event.y < 590
    images.start_game.remove
    images.start_game_clicked.y = 250
  end
end

# Event handler for mouse click up on main screen button.
# Removes 'clicked' image and brings logo & rules image onto Window.
on :mouse_up do |event|
  if event.x > 270 && event.x < 640 && event.y > 530 && event.y < 590
    images.start_game_clicked.remove
    images.logo.y = -50
    images.rules.y = 100
  end
end

$returns = []
@computer_turn = false
@player_turn = false

# Event handler for key click on rules, clues and maker screens.
# Removes rules image and brings 'clues' image onto Window, if 'c' is pressed.
# if the 'm' key is pressed, user becomes the maker.
# if the 'b' key is pressed, user becomes the breaker.
on :key_down do |event|
  if event.key == 'c'
    images.rules.remove
    images.clues.y = 150
  elsif event.key == 'm'
    # add code for maker
    images.clues.remove
    images.maker.y = 0
    @computer_turn = true
  elsif event.key == 'b'
    # add code for breaker
    images.clues.remove
    human_solver.set_computer_master_code
    images.master_code_set.y = 350
    pegs.master_code_created?(event.key)
    @player_turn = true
  end

  peg_options = ['1', '2', '3', '4', '5', '6']

  if peg_options.include?(event.key) && @computer_turn == true
    pegs.maker_pegs(event.key)
  elsif peg_options.include?(event.key)
    pegs.player_pegs(event.key)
  end

  # Conditional logic for clearing the window after master code has been set and then controlling the turns 
  # of the player.
  if event.key == 'return'
    if @player_turn == true
      $returns << event.key
      counter = $returns.size
      if counter == 1
        clear
        images.logo.y = -50
        images.logo.add
        images.turn.y = 80
        images.turn.add
        counter += 1
      elsif counter == 2
        puts "it worked!"
      elsif counter == 3
        puts "yay! it worked again"
      end
    end
    if @computer_turn == true
      clear
      images.logo.y = -50
      images.logo.add
    end
    pegs.master_code_created?(event.key)
  end

  # Controls for Background
  # Event handler is set up to detect key presses and change the speed of the squares in response.
  if event.key == 'left'
    background.squares_left
  elsif event.key == 'right'
    background.squares_right
  elsif event.key == 'up'
    background.squares_up
  elsif event.key == 'down'
    background.squares_down
  end
end

# Ruby2D built-in loop method that handles setting random falling affect speed, adds squares
# and sets speed according to the above key events.
update do
  background.populate_squares
end

show
