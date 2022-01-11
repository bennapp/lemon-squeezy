require 'nokogiri'
require 'open-uri'

class FinancialScraper
    def scrape
        hsi_url = "https://www.highshortinterest.com/"
        hsi_html = URI.open(hsi_url)
        hsi_doc = Nokogiri::HTML(hsi_html)

        table = hsi_doc.at('.stocks')

        cells = table.search('tr').map do |tr|
            tr.search('th, td')
        end

        tickers = cells
            .map { |cell| cell[0].children.first.text }
            .select { |ticker| !ticker.include?('google_ad_client') }[1..-1]

        tickers.each do |ticker|
          finviz_url = "https://finviz.com/quote.ashx?t=#{ticker}"
          finviz_html = URI.open(finviz_url)
          finviz_doc = Nokogiri::HTML(finviz_html)

          metric_names = finviz_doc.search('.snapshot-td2-cp').map { |cell| cell.children.text }
          metrics = finviz_doc.search('.snapshot-td2').map { |cell| cell.children.text }
          metric_lookup = metric_names.zip(metrics).to_h

          ts = ::TickerSnapshot.new
          ts.full_payload = metric_lookup
          ts.symbol = ticker
          ts.volume = metric_lookup["Volume"].gsub(',', '').to_i
          ts.volatility = metric_lookup["Volatility"].gsub('%', '').to_f
          ts.short_float = metric_lookup["Short Float"].gsub('%', '').to_f
          ts.short_ratio = metric_lookup["Short Ratio"].to_f
          ts.shares_float = metric_lookup["Shs Float"].gsub('M', '').to_i * 1_000_000
          ts.rsi = metric_lookup["RSI (14)"].to_f
          ts.save!

          sleep 1
        end
    end
end