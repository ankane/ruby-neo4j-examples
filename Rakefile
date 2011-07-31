desc "Import movie data into Neo4j"
task :import do
  require "database"

  File.open("performance.tsv") do |f|
    db = Database.new

    count = 0

    f.gets # header
    f.each_line do |line|
      _, _, actor_name, movie_name = line.split "\t"
      next if actor_name.empty? || movie_name.empty?

      actor = db.find_or_create "actor", actor_name
      movie = db.find_or_create "movie", movie_name
      db.acted_in actor, movie

      count += 1
      puts count if count % 100 == 0
    end
  end
end

desc "How many degrees?"
task :degrees do
  require "database"

  db = Database.new
  path = db.shortest_path "Kevin Bacon", "Sydney Park" # "Lil Wayne"

  previous = path.shift
  @results = path.each_slice(2).map do |slice| # Line 6
    movie, actor = slice
    puts result = %Q(#{previous} was in "#{movie}" with #{actor})
    previous = actor
    result
  end

  #puts db.find("actor", "Kevin Bacon")["all_typed_relationships"]
end
