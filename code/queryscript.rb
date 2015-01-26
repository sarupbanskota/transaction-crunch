require 'mysql2'

client = Mysql2::Client.new( 
			    username: ENV["MYSQL_USERNAME"], 
			    password: ENV["MYSQL_PASSWORD"],
			    database: ENV["MYSQL_DATABASE"]
		           )

id_list = client.query("select distinct id from csvdump")
total_ids = id_list.count
id_list.each { |row| system "echo #{row["id"]} >> idlisting" }
File.open("idlisting") do |file|
  file.each_line do |line|
    item_list = print "#{line}/#{total_ids}" 
    item_list = client.query("select distinct item from csvdump where id=#{line}")
    item_list.each { |entry| system "echo #{entry["item"]} >> finallist" }
  end
end
    
 
