# frozen_string_literal: true

class Url < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers

  def validate
    super

    validates_presence [:url, :shortcode]
    validates_format /^[0-9a-zA-Z_]{6}$/, :shortcode, message: 'is not a valid shortcode'
    validates_unique :shortcode
  end
end
