require 'sinatra'
require 'slim'

class Pitchomat < Sinatra::Base
	get '/pitchme' do
		slim :pitch
	end
end