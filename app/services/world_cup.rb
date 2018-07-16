module WorldCup
  require 'faraday'
  require 'json'

  def self.matches
    response = Faraday.get 'https://worldcup.sfg.io/matches'
    data = JSON.parse response.body
    data.map { |match| WorldCup::Match.new(match) }
  end

  def self.matches_on(date)
    matches.select { |match| match.check_date(date) if date }
  end
end
