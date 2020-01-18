# frozen_string_literal: true

require 'spec_helper'

describe Url, type: :model do
  let(:url) { Fabricate.build(:url) }

  context 'Validaton' do
    it 'validates presense of url' do
      url.set(url: nil, shortcode: nil)

      expect(url).not_to be_valid

      expect(url.errors).to eq(url: ['is not present'])
    end

    it 'validates shortcode format' do
      url.set(shortcode: 'short')

      expect(url).not_to be_valid

      expect(url.errors).to eq(shortcode: ['is not a valid shortcode'])
    end

    it 'validates shortcode uniquiness' do
      Fabricate(:url, shortcode: 'exist1')

      url.set(shortcode: 'exist1')

      expect(url).not_to be_valid

      expect(url.errors).to eq(shortcode: ['is already taken'])
    end
  end
end
