class GBGenre
	def initialize(id, name)
		self.id = id
		self.name = name

		yield self if block_given?
	end

	def self.new_genres_from_genres_json(json)
		json["results"].map do |result|
			g = GBGenre.new(result["id"].to_i, result["name"]) do |genre|
				genre.load_genres_result(result)
			end
		end
	end

	def load_genres_result(json)
		self.date_added = DateTime.strptime(json["date_added"], "%Y-%m-%d %H:%M:%S")
		self.link_out = json["site_detail_url"]
	end

	def load_games_json(json)
		self.n_games = json["number_of_total_results"].to_i
	end

	attr_accessor :id
	attr_accessor :name

	attr_accessor :date_added
	attr_accessor :link_out

	attr_accessor :n_games
end