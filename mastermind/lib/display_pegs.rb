require 'ruby2d'
require_relative 'display_images.rb'

class DisplayPegs < DisplayImages
    attr_reader :start_game, :start_game_clicked, :logo, :rules, :clues, :maker, :master_code_set
    attr_accessor :master_peg_placement, :peg_placement, :peg_choice, :created_pegs, :master_code, :counter

    # include GameLogic

# Hash to map each key to its corresponding image file
  PEG_IMAGE_MAP = {
    '1' => 'red_peg',
    '2' => 'blue_peg',
    '3' => 'green_peg',
    '4' => 'yellow_peg',
    '5' => 'orange_peg',
    '6' => 'purple_peg'
  }

  @@guess = []
  
  def initialize
    @master_peg_placement = [[350, 485], [400, 485], [450, 485], [500, 485]] # Master code
    @peg_placement = [
        [150, 50], [200, 50], [250, 50], [300, 50], # 1st turn
        [150, 100], [200, 100], [250, 100], [300, 100], # 2nd turn
        [150, 150], [200, 150], [250, 150], [300, 150], # 3rd turn
        [150, 200], [200, 200], [250, 200], [300, 200], # 4th turn
        [150, 250], [200, 250], [250, 250], [300, 250], # 5th turn
        [150, 300], [200, 300], [250, 300], [300, 300], # 6th turn
        [150, 350], [200, 350], [250, 350], [300, 350], # 7th turn
        [150, 400], [200, 400], [250, 400], [300, 400], # 8th turn
        [150, 450], [200, 450], [250, 450], [300, 450], # 9th turn
        [150, 500], [200, 500], [250, 500], [300, 500], # 10th turn
        [150, 550], [200, 550], [250, 550], [300, 550], # 11th turn
        [150, 600], [200, 600], [250, 600], [300, 600], # 12th turn
    ]
    @peg_choice = []
    @created_pegs = []
    @master_code = []

    @counter = 0
    @master_code_created = false
  end

  def maker_pegs(event)
    @master_code << event
    @counter = @master_code.size
    if @counter == 4
        image = DisplayImages.new
        image.master_code_set.y = 550
        @master_code_created = true
    end
    if @counter <= 4
      next_peg = @master_peg_placement[@peg_choice.size]
      unless @created_pegs.include?(next_peg)
      @peg_choice << event
      peg_color = PEG_IMAGE_MAP[event]
      peg = Image.new(
        "img/pegs/#{peg_color}.png",
        x: next_peg[0],
        y: next_peg[1],
        height: 30,
        width: 30
      )
      peg.add
      @created_pegs << next_peg
      end
    end
  end
 
  def player_pegs(event)
    updated_peg_placement = @peg_placement.map { |coord| [coord[0]-10, coord[1]+100] }
    next_peg = updated_peg_placement[@peg_choice.size]
    unless @created_pegs.include?(next_peg)
      @peg_choice << event
      peg_color = PEG_IMAGE_MAP[event]
      peg = Image.new(
        "img/pegs/#{peg_color}.png",
        x: next_peg[0],
        y: next_peg[1],
        height: 30,
        width: 30
      )
      peg.add
      @created_pegs << next_peg
    end
  end

  def computer_pegs(event)
    next_peg = @peg_placement[@peg_choice.size]
    unless @created_pegs.include?(next_peg)
      @peg_choice << event
      peg_color = PEG_IMAGE_MAP[event]
      peg = Image.new(
        "img/pegs/#{peg_color}.png",
        x: next_peg[0],
        y: next_peg[1],
        height: 30,
        width: 30
      )
      peg.add
      @created_pegs << next_peg
    end
  end 

  def master_code_created?(event)
    if event == 'b'
      @master_code_created = true
    elsif event == 'return'
      @master_code_created = nil
    end
  end
end