# frozen_string_literal: true

require 'spec_helper'

describe 'Api' do
  let(:url) { Fabricate(:url) }

  before(:each) do
    API.enable :raise_errors
    Timecop.freeze
  end

  after(:each) do
    Timecop.return
  end

  describe 'GET /:shortcode' do
    context 'shortcode exists' do
      it 'redirects to original url' do
        get "/#{url.shortcode}"

        expect(last_response.status).to eq(302)
        expect(last_response.headers['Location']).to eq(url.url)
      end

      it 'increments redirect_count and updates last_visit' do
        expect {
          get "/#{url.shortcode}"
        }.to change { url.reload.redirect_count }.by(+1)
         .and change { url.reload.last_visit }
      end
    end

    context 'shortcode does not exist' do
      it 'returns 404' do
        get "/unknown"

        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'GET /:shortcode/stats' do
    context 'shortcode exists' do
      context 'has visits' do
        before { url.increase_redirect_count }

        it 'returns url stats' do
          get "/#{url.shortcode}/stats"

          expect(parsed_response).to eq(
            'startDate' => Time.now.utc.iso8601,
            'lastSeenDate' => Time.now.utc.iso8601,
            'redirectCount' => 1
          )
        end
      end

      context 'no visits' do
        it 'returns url stats' do
          get "/#{url.shortcode}/stats"

          expect(parsed_response).to eq(
            'startDate' => Time.now.utc.iso8601,
            'redirectCount' => 0
          )
        end
      end
    end

    context 'shortcode does not exist' do
      it 'returns 404' do
        get "/unknown/stats"

        expect(last_response.status).to eq(404)
      end
    end
  end
end
