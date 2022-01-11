class SqueezesController < ApplicationController
  def index
    @ticker_info = TickerSnapshot.all
    render "squeezes/index"
  end
end
