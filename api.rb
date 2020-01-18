# frozen_string_literal: true

require 'sinatra/base'

class API < Sinatra::Base
  before do
    content_type :json
    headers 'Content-Type' => 'application/json; charset=utf-8'
  end

  get '/:shortcode' do
    url = find_url

    url.increase_redirect_count
    redirect url.url, 302
  end

  get '/:shortcode/stats' do
    url = find_url

    {}.tap do |response|
      response['startDate'] = url.created_at.utc.iso8601
      response['lastSeenDate'] = url.last_visit.utc.iso8601 if url.last_visit
      response['redirectCount'] = url.redirect_count
    end.to_json
  end

  post '/shorten' do
    data = {
      'url': 'http://example.com',
      'shortcode': 'example'
    }

    response = {
      'shortcode': data['shortcode']
    }

    response.to_json
  end

  def find_url
    found_url = Url.find(shortcode: params[:shortcode])
    found_url || halt(404)
  end
end
