module WorldCup
  class Match
    attr_accessor :venue, :status, :starts_at
    attr_reader :home_team, :away_team
    attr_reader :home_team_events, :away_team_events

    def initialize(match)
      @venue = match['venue']
      @status = match['status']
      @starts_at = Time.zone.strptime(match['datetime'], '%Y-%m-%dT%H:%M%s')

      @home_team = match['home_team']
      @away_team = match['away_team']

      @home_team_events = team_events('home')
      @away_team_events = team_events('away')
    end

    def home_team_goals
      home_team_events.select(&:goal?)
    end

    def home_team_name
      home_team['country']
    end

    def home_team_code
      home_team['code']
    end

    def away_team_goals
      away_team_events.select(&:goal?)
    end

    def away_team_name
      away_team['country']
    end

    def away_team_code
      away_team['code']
    end

    def events
      home_team_events + away_team_events
    end

    def goals
      home_team_goals + away_team_goals
    end

    def team_events(team)
      match["#{team}_team_events"]
        .map do |event|
          WorldCup::Event.new('id' => event['id'],
                              'type' => event['type_of_event'],
                              'player' => event['player'],
                              'time' => event['time'])
        end
    end
  end
end
