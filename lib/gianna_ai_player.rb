# frozen_string_literal: true

# This class is needed to add a GiannaAI in the game
class GiannaAIPlayer < Player
  def play_symbol!; end

  def to_s
    'Gianna AI'
  end
end

require 'benchmark'
Benchmark.bm(9)  do |x|
  x.report('format  :') { '%099999999d' % 0 }
  x.report('multiply:') { '0' * 99999999 }
end
