require 'mysql2'

client = Mysql2::Client.new( 
			    username: ENV["MYSQL_USERNAME"], 
			    password: ENV["MYSQL_PASSWORD"],
			    database: ENV["MYSQL_DATABASE"]
		           )

id_list = client.query("select distinct id from csvdump")
total_ids = id_list.count
id_list.each { |row| system "echo #{row["id"]} >> idlisting.xp" }
index = 1
File.open("idlisting.xp") do |file|
  file.each_line do |line|
    item_list = print "Querying (#{index}/#{total_ids}). ID #{line}" 
    item_list = client.query("select item from csvdump where id=#{line}")
    system "echo -ne '#{line.gsub("\n", "")}' >> input_list.xp"
    item_list.each { |entry| system "echo -ne ',#{entry["item"]}' >> input_list.xp" }
    system "echo -n '\n' >> input_list.xp"
    index+=1
  end
end
    
 
