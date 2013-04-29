require 'json'
require 'sinatra'
require 'slim'
require 'yaml'

require './gb-concept'
require './gb-genre'

CONCEPTS_PATH = "./concepts.yml"
GENRES_PATH = "./genres.yml"
POKEMON_PATH = "./pokemon.txt"

class PitchomatHelpers
	def initialize
		puts "boop"
		@concepts = YAML.load(File.open(CONCEPTS_PATH))
		@genres = YAML.load(File.open(GENRES_PATH))
		@pokemon = load_pokemon
	end

	# load newline-delimited list of pokemon from file, strip off whitespace
	def load_pokemon
		File.open(POKEMON_PATH).readlines.map { |pkmn| pkmn.strip }
	end

	# some well-meaning asshole submitted every pokemon as a concept page to the GB wiki
	# so we need to preflight concepts to make sure they're not pokemon
	def is_pokemon?(concept)
		!!(@pokemon.index(concept.name))
	end

	def random_genre
		i = rand(@genres.length)
		genre = @genres[i]

		genre
	end

	def random_concept
		# choose only non-pokemon concepts for now
		begin
			i = rand(@concepts.length)
			concept = @concepts[i]
		end while is_pokemon?(concept)

		concept
	end

	def get_concept(id)
		@concepts.find { |concept| concept.id == id }
	end

	def get_genre(id)
		@genres.find { |genre| genre.id == id }
	end
end

PITCHOMAT = PitchomatHelpers.new

class Pitchomat < Sinatra::Base
	get '/pitchme' do
		slim :pitch, :locals => 
			{
				title: "<Insert Title Here>",
				genre: Array.new(1) { PITCHOMAT.random_genre },
				concepts: Array.new(2) { PITCHOMAT.random_concept }
			}
	end

	get '/pitch' do
		genre_list = (params['g'] or '')
		concept_list = (params['c'] or '')

		genres = genre_list.split(',').map { |id| PITCHOMAT.get_genre(id.to_i) }
		concepts = concept_list.split(',').map { |id| PITCHOMAT.get_concept(id.to_i) }

		# puts genres.inspect
		# puts concepts.inspect

		slim :pitch, :locals =>
			{
				title: (params['title'] or "<Insert Title Here>"),
				genre: genres,
				concepts: concepts
			}
	end

	get '/ajax/genre' do
		json = PITCHOMAT.random_genre.to_json

		return json
	end

	get '/ajax/concept' do
		json = PITCHOMAT.random_concept.to_json

		return json
	end
end