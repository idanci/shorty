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
    end

    context 'shortcode does not exist' do
      it 'returns 404' do
        get "/unknown"

        expect(last_response.status).to eq(404)
      end
    end
  end
end
