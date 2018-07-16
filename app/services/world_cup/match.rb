module WorldCup
  class Match
    attr_accessor :venue, :status, :starts_at
    attr_reader :home_team, :away_team
    attr_reader :home_team_events, :away_team_events

    def initialize(match)
      @venue = match['venue']
      @status = match['status']
      @starts_at = Time.parse(match['datetime']).utc

      @home_team = match['home_team']
      @away_team = match['away_team']

      @home_team_events = team_events(match, 'home')
      @away_team_events = team_events(match, 'away')
    end

    def home_team_goals
      home_team_events.select(&:any_goal?).length
    end

    def home_team_name
      home_team['country']
    end

    def home_team_code
      home_team['code']
    end

    def away_team_goals
      away_team_events.select(&:any_goal?).length
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
      home_team_events
        .select(&:any_goal?) + away_team_events.select(&:any_goal?)
    end

    def score
      if status == 'future'
        '--'
      else
        "#{home_team_goals} : #{away_team_goals}"
      end
    end

    def as_json(_opts)
      { away_team: away_team_name,
        goals: goals.present? ? '--' : goals.length,
        home_team: home_team_name,
        score: score,
        status: status,
        venue: venue }
    end

    def team_events(match, team)
      match["#{team}_team_events"]
        .map do |event|
          WorldCup::Event.new('id' => event['id'],
                              'type_of_event' => event['type_of_event'],
                              'player' => event['player'],
                              'time' => event['time'])
        end
    end
  end
end
