# class Url < Sequel::Model
#   plugin :validation_helpers

#   def validate
#     super

#     errors.add(:url, 'cannot be empty') if !url || url.empty?
#     errors.add(:shortcode, 'cannot be empty') if !shortcode || shortcode.empty?

#     validates_presence [:url, :shortcode]
#     validates_format /^[0-9a-zA-Z_]{6}$/, :shortcode, message: 'is not a valid shortcode'
#   end
# end
