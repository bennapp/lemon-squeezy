namespace :scrape do
  desc "TODO"
  task high_shorts: :environment do
    Scraper.new.scrape
  end

end
