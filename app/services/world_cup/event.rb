module WorldCup
  class Event
    attr_accessor :id, :type, :player, :time

    def initialize(hash)
      @id = hash['id']
      @type = hash['type_of_event']
      @player = hash['player']
      @time = hash['time']
    end

    def to_s
      "##{id}: #{type}@#{time} - #{player}"
    end
  end
end
