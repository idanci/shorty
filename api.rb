# frozen_string_literal: true

require 'sinatra'

get '/:shortcode' do
  content_type :json

  redirect 'http://www.example.com', 302
end

get '/:shortcode/stats' do
  content_type :json

  {
    'startDate': '2012-04-23T18:25:43.511Z',
    'lastSeenDate': '2012-04-23T18:25:43.511Z',
    'redirectCount': 1
  }.to_json
end

post '/shorten' do
  content_type :json

  data = {
    'url': 'http://example.com',
    'shortcode': 'example'
  }

  response = {
    'shortcode': data['shortcode']
  }

  response.to_json
end
