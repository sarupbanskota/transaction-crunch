include Math
require "json"

# Takes two hashes, returns array with
# common hash keys
def common_items hash_a, hash_b
	common = []
	hash_a.each do |key, value|
		common << key unless hash_b[key].nil?
	end
	common
end

def euclidean_distance point_a, point_b
	sum = 0
	common = common_items point_a, point_b
	return 0 unless common.length
	common.each do |object|
		sum += ( point_a[object].to_f - point_b[object].to_f ) ** 2
	end
	sum
end

def euclidean_distance_score point_a, point_b
	1.0 / (1 + euclidean_distance(point_a, point_b))
end

def pearson_sum point_a, point_b
	common = common_items point_a, point_b
	sum1 = 0
	sum2 = 0
	sum1sq = 0
	sum2sq = 0
	psum = 0
	numerator = 0
	denominator = 0
	length = common.length
	return 0 unless length
	common.each do |object|
		sum1 += point_a[object].to_f
		sum1sq += point_a[object].to_f ** 2
		sum2 += point_b[object].to_f
		sum2sq += point_b[object].to_f ** 2
		psum += point_a[object].to_f * point_b[object].to_f
	end
	numerator = psum - ((sum1 * sum2)/length)
	denominator = sqrt((sum1sq - (sum1 ** 2)/length) * (sum2sq - (sum2 ** 2)/length))
  denominator ? numerator/denominator : 0 
end

def top_matches target, items
	matches = {}
	items.each do |key, value|
		matches[key] =  euclidean_distance_score target, items[key]
	end
	matches
end

## Everything below is movie specific
#broken
def sum_of_ratings movie, person, critics_hash
	scores = top_matches person, critics_hash
end

def has_watched? movie, person
	person.each do |m, v|
		return true if m == movie
	end
	false
end

def people_list critics_hash
	people = []
	critics_hash.each do |p, d|
		people << p
	end
	people
end

def movie_list critics_hash
	movie_list = []
	critics_hash.each do |critic, movies|
		movies.each do |key, value|
			movie_list << key unless movie_list.include? key
		end
	end
	movie_list
end

def movie_rated_count movie, critics_hash
	count = 0
	people_list(critics_hash).each do |person|
		critics_hash[person].each do |m, v|
			count += 1 if m == movie
		end
	end
	count
end


def movie_score guy, critics_hash
	people = top_matches guy, critics_hash
	movie_scores = {}
	movies = movie_list critics_hash
	movies.each do |movie|
		movie_score = 0
		people.each do |person|
			if has_watched? movie, critics_hash[person.first]
				movie_scores[movie] = 0
				movie_scores[movie] += critics_hash[person.first][movie].to_f * people[person.first].to_f
			end
		end
		movie_scores[movie] /= movie_rated_count movie, critics_hash
	end
	movie_scores
end

critics = '{"Lisa Rose": {"Lady in the Water": 2.5, "Snakes on a Plane": 3.5,
"Just My Luck": 3.0, "Superman Returns": 3.5, "You, Me and Dupree": 2.5,
"The Night Listener": 3.0},
"Gene Seymour": {"Lady in the Water": 3.0, "Snakes on a Plane": 3.5,
"Just My Luck": 1.5, "Superman Returns": 5.0, "The Night Listener": 3.0,
"You, Me and Dupree": 3.5},
"Michael Phillips": {"Lady in the Water": 2.5, "Snakes on a Plane": 3.0,
"Superman Returns": 3.5, "The Night Listener": 4.0},
"Claudia Puig": {"Snakes on a Plane": 3.5, "Just My Luck": 3.0,
"The Night Listener": 4.5, "Superman Returns": 4.0,
"You, Me and Dupree": 2.5},
"Mick LaSalle": {"Lady in the Water": 3.0, "Snakes on a Plane": 4.0,
"Just My Luck": 2.0, "Superman Returns": 3.0, "The Night Listener": 3.0,
"You, Me and Dupree": 2.0},
"Jack Matthews": {"Lady in the Water": 3.0, "Snakes on a Plane": 4.0,
"The Night Listener": 3.0, "Superman Returns": 5.0, "You, Me and Dupree": 3.5},
"Toby": {"Snakes on a Plane":4.5,"You, Me and Dupree":1.0,"Superman Returns":4.0}}'

critics_hash = JSON.parse critics
#puts "Euclidean: #{euclidean_distance_score critics_hash["Lisa Rose"], critics_hash["Gene Seymour"]}"
#puts "Pearson: #{pearson_sum critics_hash["Lisa Rose"], critics_hash["Gene Seymour"]}"
#puts "Scores: #{top_matches critics_hash["Lisa Rose"], critics_hash}"

#recommend critics_hash["Lisa Rose"], critics_hash
#puts sum_of_ratings "Snakes on a Plane", critics_hash["Lisa Rose"], critics_hash
#puts has_watched? "Superman Returns", critics_hash["Toby"]

#recommend "Toby", critics_hash
#movie_list critics_hash

#puts movie_rated_count "Lady in the Water", critics_hash

puts movie_score critics_hash["Toby"], critics_hash