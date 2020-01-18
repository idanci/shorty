# frozen_string_literal: true

require 'sinatra/base'

class API < Sinatra::Base
  before do
    headers 'Content-Type' => 'application/json; charset=utf-8'
    params.merge!(JSON.parse(request.body.read)) if request.post?
  end

  get '/:shortcode' do
    url = find_url

    url.increase_redirect_count
    redirect url.url, 302
  end

  get '/:shortcode/stats' do
    content_type :json

    url = find_url

    {}.tap do |response|
      response['startDate'] = url.created_at.utc.iso8601
      response['lastSeenDate'] = url.last_visit.utc.iso8601 if url.last_visit
      response['redirectCount'] = url.redirect_count
    end.to_json
  end

  post '/shorten' do
    content_type :json

    validate_request

    status 201

    { 'shortcode': Url.create(params.slice(:url, :shortcode)).shortcode }.to_json
  end

  # rubocop:disable Metrics/AbcSize
  def validate_request
    halt(400) if params[:url].to_s.empty?
    halt(422) if !params[:shortcode].nil? && !params[:shortcode].to_s.match?(Url::SHORTCODE_REGEX)
    halt(409) if find_url(raise_on_missing: false)
  end
  # rubocop:enable Metrics/AbcSize

  def find_url(raise_on_missing: true)
    found_url = Url.find(shortcode: params[:shortcode])
    return found_url if found_url

    halt(404) if raise_on_missing
  end
end
