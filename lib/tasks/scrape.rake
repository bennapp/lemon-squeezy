namespace :scrape do
  desc "TODO"
  task high_shorts: :environment do
    FinancialScraper.new.scrape
  end

  # Note this is currently not working
  task trends: :environment do
    TrendsScraper.new.scrape
  end
end
