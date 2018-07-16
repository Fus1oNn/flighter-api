require 'table_print'

namespace :world_cup do
  desc 'print match scores in a table view'
  task :scores, [:date] => [:environment] do |_task, args|
    # date = Date.parse(args[:date])
    # puts "Scores on #{args[:date]}"
    include WorldCup
    tp WorldCup.matches_on(Date.parse(args[:date]))
  end
end
