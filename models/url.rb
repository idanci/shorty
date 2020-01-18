# frozen_string_literal: true

class Url < Sequel::Model
  plugin :timestamps
  plugin :touch
  plugin :validation_helpers

  def increase_redirect_count
    DB.transaction do
      set(redirect_count: redirect_count + 1)
      touch(:last_visit)
    end
  end

  def validate
    super

    validates_presence [:url, :shortcode]
    validates_format /^[0-9a-zA-Z_]{6}$/, :shortcode, message: 'is not a valid shortcode'
    validates_unique :shortcode
  end
end
