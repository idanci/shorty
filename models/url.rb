# frozen_string_literal: true

class Url < Sequel::Model
  SHORTCODE_REGEX = /^[0-9a-zA-Z_]{6}$/.freeze

  plugin :timestamps
  plugin :touch
  plugin :validation_helpers

  def before_validation
    if [id, shortcode].none?
      self.shortcode = loop do
        random_shortcode = SecureRandom.alphanumeric(6)
        break random_shortcode unless Url.find(shortcode: random_shortcode)
      end
    end

    super
  end

  def increase_redirect_count
    DB.transaction do
      set(redirect_count: redirect_count + 1)
      touch(:last_visit)
    end
  end

  def validate
    super

    validates_presence [:url, :shortcode]
    validates_format SHORTCODE_REGEX, :shortcode, message: 'is not a valid shortcode'
    validates_unique :shortcode
  end
end
