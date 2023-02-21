require 'ruby2d'
require_relative 'display_pegs.rb'

class HumanSolver < DisplayPegs
    attr_reader :guess
    attr_accessor :computer_code

    def initialize
      @computer_code = 0
    end

    def set_computer_master_code
      random_numbers = [rand(1..6), rand(1..6), rand(1..6), rand(1..6)]
      @computer_code = random_numbers.map(&:to_s)
    end

end