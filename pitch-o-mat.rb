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
end

PITCHOMAT = PitchomatHelpers.new

class Pitchomat < Sinatra::Base
	get '/pitchme' do
		slim :pitch, :locals => { :pitchomat => PITCHOMAT }
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