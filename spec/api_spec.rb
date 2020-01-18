# frozen_string_literal: true

require 'spec_helper'

describe 'Api' do
  let(:existing_url) { Fabricate(:url) }

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
        get "/#{existing_url.shortcode}"

        expect(last_response.status).to eq(302)
        expect(last_response.headers['Location']).to eq(existing_url.url)
      end

      it 'increments redirect_count and updates last_visit' do
        expect {
          get "/#{existing_url.shortcode}"
        }.to change { existing_url.reload.redirect_count }.by(+1)
         .and change { existing_url.reload.last_visit }
      end
    end

    context 'shortcode does not exist' do
      it 'returns 404 status' do
        get '/unknown'

        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'GET /:shortcode/stats' do
    context 'shortcode exists' do
      context 'has visits' do
        before { existing_url.increase_redirect_count }

        it 'returns url stats' do
          get "/#{existing_url.shortcode}/stats"

          expect(parsed_response).to eq(
            'startDate' => Time.now.utc.iso8601,
            'lastSeenDate' => Time.now.utc.iso8601,
            'redirectCount' => 1
          )
        end
      end

      context 'no visits' do
        it 'returns url stats' do
          get "/#{existing_url.shortcode}/stats"

          expect(parsed_response).to eq(
            'startDate' => Time.now.utc.iso8601,
            'redirectCount' => 0
          )
        end
      end
    end

    context 'shortcode does not exist' do
      it 'returns 404 status' do
        get '/unknown/stats'

        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'POST /shorten' do
    let(:url_param) { 'http://example.com' }
    let(:shortcode_param) { 'qwe123' }
    let(:params) do
      {
        url: url_param,
        shortcode: shortcode_param
      }
    end

    context 'valid request' do
      before do
        existing_url
        expect { post '/shorten', params }.to change { Url.count }.by(+1)
      end

      context 'shortcode is empty' do
        let(:shortcode_param) { nil }

        it 'saves the url and returns assigned shortcode' do
          expect(last_response.status).to eq(201)

          created_url = Url.last

          expect(parsed_response).to eq('shortcode' => created_url.shortcode)
        end
      end

      context 'shortcode is present' do
        it 'saves the url and returns assigned shortcode' do
          expect(last_response.status).to eq(201)

          created_url = Url.last

          expect(created_url.shortcode).to eq(shortcode_param)
          expect(parsed_response).to eq('shortcode' => shortcode_param)
        end
      end
    end

    context 'invalid request' do
      before do
        existing_url
        expect { post '/shorten', params }.not_to change { Url.count }
      end

      context 'url missing' do
        let(:url_param) { nil }

        it 'returns 400 status' do
          expect(last_response.status).to eq(400)
        end
      end

      context 'shortcode already in use' do
        let(:shortcode_param) { existing_url.shortcode }

        it 'returns 409 status' do
          expect(last_response.status).to eq(409)
        end
      end

      context 'shortcode invalid' do
        let(:shortcode_param) { 'invalid_shortcode' }

        it 'returns 422 status' do
          expect(last_response.status).to eq(422)
        end
      end
    end
  end
end
