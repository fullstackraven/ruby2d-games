require 'ruby2d'
require 'yaml'
require 'thread'
class Hangman
  def initialize(game_state = nil)
    # The coordinates where each incorrect guess will be drawn
    @incorrect_guess_placement = [
      { x: 170, y: 640 }, { x: 255, y: 640 }, { x: 340, y: 640 }, { x: 420, y: 640 },
      { x: 505, y: 640 }, { x: 590, y: 640 }
    ]
    @incorrect_guess_placement_map = {}
    @incorrect_guess_placement.each_with_index do |coordinates, index|
      @incorrect_guess_placement_map[index + 1] = coordinates
    end

    # If game state is not given, start a new game; otherwise, load the saved game state
    if game_state.nil?
      new_game
    else
      load_game(game_state)
    end
  end

  def new_game
    # Load a dictionary and select a secret word
    @dictionary = load_dictionary
    @secret_word = select_secret_word(@dictionary)

    # Create arrays to store correct, incorrect guesses and initialize coordinates
    @correct_guesses = Array.new(@secret_word.length, '_')
    @incorrect_guesses = []
    @coordinates = []

    # Draw the hangman and the secret word
    draw_hangman(@incorrect_guesses.length)
    draw_secret_word(@secret_word, @correct_guesses)
  end

  def load_game(game_state)
    # Load a saved game state and set instance variables
    game_state = YAML.load(game_state)
    @secret_word = game_state['secret_word']
    @correct_guesses = game_state['correct_guesses']
    @incorrect_guesses = game_state['incorrect_guesses']
    # @coordinates = game_state['coordinates']

    # Redraw the hangman, the secret word, and the incorrect guesses
    draw_hangman(@incorrect_guesses.length)
    draw_secret_word(@secret_word, @correct_guesses)
    load_incorrect_guesses
  end

  def load_dictionary
    # Load a dictionary file and return an array of words between 5 and 12 letters long
    File.readlines('google-10000-english-no-swears.txt').map(&:strip).select { |word|
      word.length.between?(5, 12)
    }
  end

  def select_secret_word(dictionary)
    # Select a word from loaded dictionary that is limited to 10 characters
    dictionary.select { |word| word.length <= 10 }.sample.upcase
  end

  def draw_hangman(guess_length)
    # Draw the head
    @head_outline = Circle.new(x: 312, y: -180, radius: 30, sectors: 32, color: 'black')
    @head_outline.add
    @head_void = Circle.new(x: 312, y: -180, radius: 25, sectors: 32, color: 'olive')
    @head_void.add

    # Draw the body
    @body = Line.new(x1: 312, y1: -210, x2: 312, y2: -290, width: 5, color: 'black')
    @body.add

    # Draw the left arm
    @left_arm = Line.new(x1: 310, y1: -230, x2: 260, y2: -260, width: 5, color: 'black')
    @left_arm.add

    # Draw the right arm
    @right_arm = Line.new(x1: 313, y1: -230, x2: 360, y2: -260, width: 5, color: 'black')
    @right_arm.add

    # Draw the left leg
    @left_leg = Line.new(x1: 310, y1: -290, x2: 260, y2: -340, width: 5, color: 'black')
    @left_leg.add

    # Draw the right leg
    @right_leg = Line.new(x1: 313, y1: -290, x2: 360, y2: -340, width: 5, color: 'black')
    @right_leg.add

    # Case structured this way so that when a saved game is loaded, all the necessary body parts load as well
    case guess_length
    when 1
      @head_outline.y = 145
      @head_void.y = 145
    when 2
      @head_outline.y = 145
      @head_void.y = 145
      @body.y1, @body.y2 = 170, 245
    when 3
      @head_outline.y = 145
      @head_void.y = 145
      @body.y1, @body.y2 = 170, 245
      @left_arm.y1, @left_arm.y2 = 190, 220
    when 4
      @head_outline.y = 145
      @head_void.y = 145
      @body.y1, @body.y2 = 170, 245
      @left_arm.y1, @left_arm.y2 = 190, 220
      @right_arm.y1, @right_arm.y2 = 190, 220
    when 5
      @head_outline.y = 145
      @head_void.y = 145
      @body.y1, @body.y2 = 170, 245
      @left_arm.y1, @left_arm.y2 = 190, 220
      @right_arm.y1, @right_arm.y2 = 190, 220
      @left_leg.y1, @left_leg.y2 = 242, 300
    when 6
      @head_outline.y = 145
      @head_void.y = 145
      @body.y1, @body.y2 = 170, 245
      @left_arm.y1, @left_arm.y2 = 190, 220
      @right_arm.y1, @right_arm.y2 = 190, 220
      @left_leg.y1, @left_leg.y2 = 242, 300
      @right_leg.y1, @right_leg.y2 = 242, 300
    end
  end

  def draw_secret_word(secret_word, correct_guesses)
    # Create the label for the secret word
    @secret_word_label = Text.new(
      correct_guesses.join(' '),
      x: 220,
      y: 440,
      size: 50,
      font: '/Library/Fonts/uni05_53.ttf',
      color: 'black'
    )
  end

  def handle_input(key)
    if ('a'..'z').include?(key)
      letter = key.upcase

      if @secret_word.include?(letter)
        # Update the correct guesses and redraw the secret word label
        @secret_word.chars.each_with_index do |char, index|
          if char == letter
            @correct_guesses[index] = letter
          end
        end

        @secret_word_label.text = @correct_guesses.join(' ')

        # Check if the player has won
        if @correct_guesses.none? { |letter| letter == '_' }
          Thread.new do
            sleep(1)
            win
          end
        end
      else
        # Update the incorrect guesses and redraw the incorrect guesses label
        @incorrect_guesses.push(letter)
        draw_incorrect_guesses(letter)

        # Update the hangman drawing
        case @incorrect_guesses.length
        when 1
          @head_outline.y = 145
          @head_void.y = 145
        when 2
          @body.y1, @body.y2 = 170, 245
        when 3
          @left_arm.y1, @left_arm.y2 = 190, 220
        when 4
          @right_arm.y1, @right_arm.y2 = 190, 220
        when 5
          @left_leg.y1, @left_leg.y2 = 242, 300
        when 6
          @right_leg.y1, @right_leg.y2 = 242, 300
        end
        # Allows all body parts to display before 'lose' method called
        if @incorrect_guesses.length == 6
          Thread.new do
            sleep(1)
            lose
          end
        end
      end
    end
  end

  def draw_incorrect_guesses(letter)
    # Create the label for the incorrect guesses
    if @incorrect_guess_placement_map.keys.include?(@incorrect_guesses.length)
      @coordinates = @incorrect_guess_placement_map[@incorrect_guesses.length]
      if letter == 'W'
        @incorrect_guesses_label = Text.new(
          "#{letter}",
          x: @coordinates[:x] - 10,
          y: @coordinates[:y],
          size: 60,
          font: '/Library/Fonts/uni05_53.ttf',
          color: 'black'
        )
      else
        @incorrect_guesses_label = Text.new(
          "#{letter}",
          x: @coordinates[:x],
          y: @coordinates[:y],
          size: 60,
          font: '/Library/Fonts/uni05_53.ttf',
          color: 'black'
        )
      end
    end
  end

  def load_incorrect_guesses
    # Allow saved guesses to reappear in correct coord when loaded
    @incorrect_guesses.each_with_index do |letter, index|
      if index < @incorrect_guess_placement.size
        coord = @incorrect_guess_placement[index]
        x = coord[:x]
        y = coord[:y]
        text = Text.new(letter, x: x, y: y, size: 60, font: '/Library/Fonts/uni05_53.ttf', color: 'black')
        text.add
      end
    end
  end

  def win
    # Show a message and prompt for new game
    Image.new('img/won.png', x: 0, y: 0, width: Window.width, height: Window.height, z: 10)
  end

  def lose
    # Show a message, display word & prompt for new game
    Image.new('img/lost.png', x: 0, y: 0, width: Window.width, height: Window.height, z: 10)
    Text.new("#{@secret_word}", x: 150, y: 580, size: 60, color: 'black', font: '/Library/Fonts/uni05_53.ttf', z: 10)
  end

  def save_game_state
    # Convert game state to YAML format
    game_state = {
      'secret_word' => @secret_word,
      'correct_guesses' => @correct_guesses,
      'incorrect_guesses' => @incorrect_guesses,
      #   'coordinates' => @coordinates
    }
    yaml = YAML.dump(game_state)

    # Save YAML to a text file
    File.write('game_state.yaml', yaml)
  end

  def load_game_state
    # Read YAML from a text file
    yaml = File.read('game_state.yaml')

    # Convert YAML to game state
    game_state = YAML.load(yaml)

    # Initialize the game with the loaded game state
    initialize(YAML.dump(game_state))
  end
end
