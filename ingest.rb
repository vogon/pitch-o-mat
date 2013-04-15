require 'json'
require 'net/http'
require 'uri'
require 'yaml'

require './gb-concept'
require './gb-genre'

CONFIG = YAML.load(File.open('ingest.yaml'))

GBAPI_GENRES_BASE = "http://www.giantbomb.com/api/genres/"
GBAPI_GAMES_BASE = "http://www.giantbomb.com/api/games/"
GBAPI_CONCEPTS_BASE = "http://www.giantbomb.com/api/concepts/"

def build_gbapi_uri(base, extra_params)
	params = {
		api_key: CONFIG["api_key"],
		format: "json"
	}.merge(extra_params)

	uri = URI::parse(base)
	uri.query = URI.encode_www_form(params)

	uri
end

def get_genres
	uri = build_gbapi_uri(GBAPI_GENRES_BASE, field_list: "id,name,date_added,site_detail_url,api_detail_url")
	resp = Net::HTTP.get_response(uri)
	json = JSON.load(resp.body)

	GBGenre.new_genres_from_genres_json(json)
end

def get_concepts_page(offset)
	uri = build_gbapi_uri(GBAPI_CONCEPTS_BASE, field_list: "id,name,date_added,site_detail_url,api_detail_url", offset: offset)
	resp = Net::HTTP.get_response(uri)
	json = JSON.load(resp.body)

	return GBConcept.new_concepts_from_concepts_json(json), json["number_of_total_results"]
end

def get_concepts
	n_concepts = Float::INFINITY
	offset = 0
	concepts = []

	while offset < n_concepts do
		page, last_n = get_concepts_page(offset)

		concepts += page
		offset += page.length

		if n_concepts != last_n then
			puts "note: number of concepts changed from #{n_concepts} to #{last_n}"
			n_concepts = last_n
		end

		puts "fetched #{offset} concept names of #{n_concepts}..."
	end

	concepts
end

# puts get_genres.inspect

puts get_concepts.inspect

genres = get_genres
concepts = get_concepts

File.open('genres.yml', 'w') do |io|
	io.write(genres.to_yaml)
end

File.open('concepts.yml', 'w') do |io|
	io.write(concepts.to_yaml)
end