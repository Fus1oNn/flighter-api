RSpec.describe WorldCup::Match do
  let(:match) do
    described_class.new('venue' => 'Rostov', 'status' => 'completed',
                        'datetime' => '2018-06-20T17:00:00',
                        'home_team' => { 'country' => 'England',
                                         'code' => 'ENG',
                                         'goals' => 1 },
                        'away_team' => { 'country' => 'Croatia',
                                         'code' => 'CRO',
                                         'goals' => 2 },
                        'home_team_events' => [{ 'id' => 1,
                                                 'type_of_event' => 'own-goal',
                                                 'player' => 'Trippier',
                                                 'time' => "23'" }],
                        'away_team_events' => [{ 'id' => 3,
                                                 'type_of_event' => 'goal',
                                                 'player' => 'Ivan Perisic',
                                                 'time' => "68'" },
                                               { 'id' => 4,
                                                 'type_of_event' => 'goal',
                                                 'player' => 'Luka Modric',
                                                 'time' => "89'" }])
  end

  it 'initializes venue' do
    expect(match.venue).to eq('Rostov')
  end

  it 'initializes status' do
    expect(match.status).to eq('completed')
  end

  it 'initializes datetime' do
    expect(match.starts_at).to eq(Time.parse('2018-06-20T17:00:00').utc)
  end

  it 'gets home_team_name' do
    expect(match.home_team_name).to eq('England')
  end

  it 'gets home_team_code' do
    expect(match.home_team_code).to eq('ENG')
  end

  it 'gets home_team_goals' do
    expect(match.home_team_goals.map(&:to_s))
      .to eq(["#1: own-goal@23' - Trippier"])
  end

  it 'gets away_team_name' do
    expect(match.away_team_name).to eq('Croatia')
  end

  it 'gets away_team_code' do
    expect(match.away_team_code).to eq('CRO')
  end

  it 'gets away_team_goals' do
    expect(match.away_team_goals.map(&:to_s))
      .to eq(["#3: goal@68' - Ivan Perisic", "#4: goal@89' - Luka Modric"])
  end

  it 'gets all events' do
    expect(match.events.map(&:to_s))
      .to eq(["#1: own-goal@23' - Trippier",
              "#3: goal@68' - Ivan Perisic", "#4: goal@89' - Luka Modric"])
  end

  it 'gets all goals' do
    expect(match.goals.map(&:to_s))
      .to eq(["#1: own-goal@23' - Trippier",
              "#3: goal@68' - Ivan Perisic", "#4: goal@89' - Luka Modric"])
  end

  it 'returns Events objects on #events' do
    expect(match.events.map(&:class)).to eq([WorldCup::Event, WorldCup::Event,
                                             WorldCup::Event])
  end
end
