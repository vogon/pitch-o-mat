require 'sinatra'
require 'slim'
require 'yaml'

require './gb-concept'
require './gb-genre'

CONCEPTS_PATH = "./concepts.yml"
GENRES_PATH = "./genres.yml"

class PitchomatHelpers
	def initialize
		puts "boop"
		@concepts = YAML.load(File.open(CONCEPTS_PATH))
		@genres = YAML.load(File.open(GENRES_PATH))
	end

	def random_genre
		i = rand(@genres.length)
		genre = @genres[i]

		genre
	end

	def random_concept
		i = rand(@concepts.length)
		concept = @concepts[i]

		concept
	end	
end

PITCHOMAT = PitchomatHelpers.new

class Pitchomat < Sinatra::Base
	get '/pitchme' do
		slim :pitch, :locals => { :pitchomat => PITCHOMAT }
	end
end