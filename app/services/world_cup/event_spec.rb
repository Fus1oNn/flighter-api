RSpec.describe WorldCup::Event do
  let(:event) do
    described_class.new('id' => 276,
                        'type_of_event' => 'goal',
                        'player' => 'Luis SUAREZ',
                        'time' => "23'")
  end

  it 'initializes id' do
    expect(event.id).to eq(276)
  end

  it 'initializes type' do
    expect(event.type).to eq('goal')
  end

  it 'initializes player' do
    expect(event.player).to eq('Luis SUAREZ')
  end

  it 'initializes time' do
    expect(event.time).to eq("23'")
  end

  context 'when to_s called on it' do
    it 'formats it correctly' do
      expect(event.to_s).to eq("#276: goal@23' - Luis SUAREZ")
    end
  end
end
