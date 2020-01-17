require 'spec_helper'

describe Url, type: :model do
  let(:url) { Fabricate.build(:url) }

  context 'Validaton' do
    it 'validates presense of url and shortcode' do
      url.set(url: nil, shortcode: nil)

      expect(url).not_to be_valid

      expect(url.errors).to eq(
        url: ["is not present"],
        shortcode: ["is not present", "is not a valid shortcode"]
      )
    end
  end
end
