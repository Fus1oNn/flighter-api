module WorldCup
  require 'faraday'
  require 'json'

  class WorldCup
    def matches
      response = Faraday.get 'https://worldcup.sfg.io/matches'
      data = JSON.parse response.body
      data.map { |match| WorldCup::Match.new(match) }
    end

    def matches_on(date)
      matches.select do |match|
        match.starts_at.yday == date.yday && match.starts_at.year == date.year
      end
    end
  end
end
