class TickerSnapshot < ApplicationRecord
  VOLUME_WEIGHT = 0.1
  VOLATILITY_WEIGHT = 0.1
  SHORT_RATIO_WEIGHT = 1.0
  SHORT_FLOAT_WEIGHT = 1.0

  def squeeze_score
    metrics = [
      short_ratio_score,
      short_float_score,
      volume_score,
      volatility_score
    ]

    metrics.sum(0.0) / metrics.size * 100
  end

  def is_squeeze?
    volatility_check = volatility < 10
    volume_check = volume < 10_000_000
    short_ratio_check = short_ratio > 10
    short_float_check = short_float > 30

    short_float_check && short_ratio_check && volume_check && volatility_check
  end

  def short_ratio_score
    short_ratio / 100.to_f * SHORT_RATIO_WEIGHT
  end

  def short_float_score
    high_short_float = 50.to_f
    short_float / high_short_float * SHORT_FLOAT_WEIGHT
  end

  def volume_score
    high_volume = 50_000_000.to_f
    normalized_volume = (-volume / high_volume) + 1
    normalized_volume * VOLUME_WEIGHT
  end

  def volatility_score
    (100 - volatility) / 100.to_f * VOLATILITY_WEIGHT
  end
end
