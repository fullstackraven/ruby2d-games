require 'ruby2d'
require_relative 'display.rb'
require_relative 'hangman.rb'

set title: 'Hangman',
    width: 800,
    height: 800,
    resizable: true,
    background: 'olive'

NEW_GAME_BUTTON = { x1: 100, x2: 365, y1: 480, y2: 550 }
LOAD_GAME_BUTTON = { x1: 440, x2: 700, y1: 480, y2: 550 }
BACK_BUTTON = { x1: 4, x2: 108, y1: 25, y2: 65 }

display = Display.new
hangman = Hangman.new

reset_game = false
esc_game = false
save_game = false
game_mode = nil
button_clicked = false

on :mouse_down do |event|
  if event.x.between?(NEW_GAME_BUTTON[:x1], NEW_GAME_BUTTON[:x2]) &&
     event.y.between?(NEW_GAME_BUTTON[:y1], NEW_GAME_BUTTON[:y2])
    game_mode = :new_game
    button_clicked = true
  elsif event.x.between?(LOAD_GAME_BUTTON[:x1], LOAD_GAME_BUTTON[:x2]) &&
        event.y.between?(LOAD_GAME_BUTTON[:y1], LOAD_GAME_BUTTON[:y2])
    game_mode = :load_game
    button_clicked = true
  elsif event.x.between?(BACK_BUTTON[:x1], BACK_BUTTON[:x2]) &&
        event.y.between?(BACK_BUTTON[:y1], BACK_BUTTON[:y2])
    display.start_page.add
  end
end

update do
  if reset_game
    clear
    display = Display.new
    display.board
    hangman = Hangman.new
    reset_game = false
  end

  if save_game
    if game_mode == :new_game
      hangman.save_game_state
      display.save.remove
      clear
      display = Display.new
      game_mode = nil
      save_game = false
    elsif game_mode == :load_game
      hangman.save_game_state
      display.save.remove
      clear
      display = Display.new
      game_mode = nil
      save_game = false
    end
  end

  if game_mode == :new_game && button_clicked
    clear
    display = Display.new
    display.start_page.remove
    display.board
    hangman = Hangman.new
    button_clicked = false
  elsif game_mode == :load_game && button_clicked
    clear
    display = Display.new
    display.start_page.remove
    display.board
    hangman.load_game_state
    button_clicked = false
  end
end

on :key_down do |event|
  case event.key
  when 'return'
    reset_game = true
  when 'escape'
    esc_game = true
    if game_mode
      display.save
      display.save.y = 0
    else
      close
    end
  else
    hangman.handle_input(event.key) if game_mode && esc_game == false
  end

  if event.key == 'y' && esc_game
    if display.save && display.save.y == 0
      save_game = true
      esc_game = false
    end
  elsif event.key == 'n' && esc_game
    if display.save && display.save.y == 0
      display.save.y = -999
      esc_game = false
    end
  end
end

show
