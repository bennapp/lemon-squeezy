class TickerSnapshot < ApplicationRecord
  def squeeze_score
    high_volume = 20_000_000.to_f
    normalized_volume = volume.to_f / high_volume
    
    (short_ratio * short_float) / (normalized_volume * volatility) 
  end
end
