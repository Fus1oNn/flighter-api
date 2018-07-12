RSpec.describe WorldCup::Match do
  let(:match) do
    described_class.new('venue' => 'Rostov', 'status' => 'completed',
                        'datetime' => 'Luis SUAREZ',
                        'home_team' => { 'country' => 'England',
                                         'code' => 'ENG',
                                         'goals' => 1 },
                        'away_team' => { 'country' => 'Croatia',
                                         'code' => 'CRO',
                                         'goals' => 2 },
                        'home_team_events' => [{ 'id' => 1,
                                                 'type_of_event' => 'goal',
                                                 'player' => 'Trippier',
                                                 'time' => "23'" }],
                        'away_team_events' => [{ 'id' => 3,
                                                 'type_of_event' => 'goal',
                                                 'player' => 'Ivan Perisic',
                                                 'time' => "68'" },
                                               { 'id' => 4,
                                                 'type_of_event' => 'chance',
                                                 'player' => 'Luka Modric',
                                                 'time' => "89'" }])
  end

  it 'initializes venue' do
    expect(match.venue).to eq(Rostov)
  end
end
