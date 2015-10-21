gem 'httparty'
require 'httparty'
require 'json'


class TwitterSearch
	attr_reader :options
	include HTTParty
	base_uri "https://www.googleapis.com/youtube/v3"

	def initialize(search_term)
		@options = { query: {id:'7lCDEYXw3mM', key:'AIzaSyA6Qz6IvGspy06VQPtQlTBv4sCHqq6D19k', type: 'video',  part: 'snippet', q: search_term , maxResults: 3 } }
	end

	def search
		results = self.class.get('/search', @options) 
		hash = JSON.parse results.body
		ids = []
		hash['items'].each { |item| 
			ids << item['id']['videoId']
		}
		links =[]
		base = 'https://www.youtube.com/watch?v='
		ids.each { |obj| 
			full_url =  base + obj 
			links << full_url
		}
		return links
	end
end



twitter = TwitterSearch.new('soccer')
puts twitter.search

