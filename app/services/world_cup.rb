module WorldCup
  def self.matches
    response = Faraday.get 'https://worldcup.sfg.io/matches'
    data = JSON.parse response.body
    data.map { |match| WorldCup::Match.new(match) }
  end

  def self.matches_on(date)
    matches.select { |match| match.starts_at.to_date == date.to_date }
  end
end
