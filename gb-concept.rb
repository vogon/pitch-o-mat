class GBConcept
	def initialize(id, name)
		self.id = id
		self.name = name

		yield self if block_given?
	end

	def self.new_concepts_from_concepts_json(json)
		json["results"].map do |result|
			c = GBConcept.new(result["id"].to_i, result["name"]) do |concept|
				concept.load_concepts_result(result)
			end
		end
	end

	def load_concepts_result(json)
		self.date_added = DateTime.strptime(json["date_added"], "%Y-%m-%d %H:%M:%S")
		self.link_out = json["site_detail_url"]
	end

	def load_concept_json(json)
		self.n_games = json["results"]["games"].count
	end
	
	def to_json(options = {})
		{
			name: self.name,
			link_out: self.link_out
		}.to_json(options)
	end

	attr_accessor :id
	attr_accessor :name

	attr_accessor :date_added
	attr_accessor :link_out
	
	attr_accessor :n_games
end