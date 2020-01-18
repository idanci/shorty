# frozen_string_literal: true

require 'spec_helper'

describe 'Api' do
  describe 'GET /:shortcode' do
    let(:url) { Fabricate(:url) }

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
end
