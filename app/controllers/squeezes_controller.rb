class SqueezesController < ApplicationController
  def index
    @ticker_info = TickerSnapshot.all.sort_by { |ti| -ti.squeeze_score }
    render "squeezes/index"
  end
end
