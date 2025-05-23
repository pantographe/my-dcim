# frozen_string_literal: true

module ModelesHelper
  def lighten_color(hex_color, amount = 0.6)
    hex_color = hex_color.delete('#')
    rgb = hex_color.scan(/../).map(&:hex)
    rgb[0] = [(rgb[0].to_i + (255 * amount)).round, 255].min
    rgb[1] = [(rgb[1].to_i + (255 * amount)).round, 255].min
    rgb[2] = [(rgb[2].to_i + (255 * amount)).round, 255].min

    format("#%02x%02x%02x", *rgb)
  end
end
