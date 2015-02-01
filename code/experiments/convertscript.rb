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
	puts count_hash.to_json
end

File.open("file") do |file|
  file.each_line do |line|
  	item_list = line.split(',')[1..-1]
  	count item_list
	end
end