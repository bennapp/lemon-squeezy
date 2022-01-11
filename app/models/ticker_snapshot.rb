class TickerSnapshot < ApplicationRecord
  def squeeze_score
    (short_ratio * short_float) / (volume * volatility) 
  end
end
