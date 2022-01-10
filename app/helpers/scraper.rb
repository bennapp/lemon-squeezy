require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
    def scrape
        hsi_url = "https://www.highshortinterest.com/"
        hsi_html = URI.open(hsi_url)
        hsi_doc = Nokogiri::HTML(hsi_html)

        table = hsi_doc.at('.stocks')

        cells = table.search('tr').map do |tr|
            tr.search('th, td')
        end

        tickers = cells.map { |cell| cell[0].children.first.text }

        p tickers
    end
end

Scraper.new.scrape