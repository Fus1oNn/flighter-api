namespace :world_cup do
  desc 'Print WorldCup match scores in a table view'
  task :scores, [:date] => [:environment] do |_task, args|
    tp WorldCup.matches_on(Date.parse(args[:date])),
       :venue,
       { home_team: proc { |match| match.home_team_name } },
       { away_team: proc { |match| match.away_team_name } },
       score: { display_method: :score }
  end
end
