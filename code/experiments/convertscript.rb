# takes input as id,item1,item1,item2,item2,item3..
# and returns {id: {item1: score, item2: score}}

require 'json'

# input - item1, item1, item2..
def count item_list
	count_hash = {}
	item_list.each do |item|
		item = item.to_i
		count_hash[item] = count_hash[item] ? count_hash[item] + 1 : 1 
	end
	count_hash
end

File.open("input_list.xp") do |file|
	people_hash = {}
  file.each_line do |line|
  	item_list = line.split(',')
  	person = item_list[0]
  	people_hash[person] = count item_list[1..-1]
	end
	json = people_hash.to_json
	File.open("helloworld.xp", 'w') { |file| file.write json }
end