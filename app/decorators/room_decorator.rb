# frozen_string_literal: true

class RoomDecorator < ApplicationDecorator
  class << self
    def statuses_for_options
      Room.statuses.keys.map { |status| [Room.human_attribute_name("status.#{status}"), status] }
    end
  end

  def badge_color_for_status
    case status
    when "active"
      "text-bg-success"
    when "passive"
      "text-bg-warning"
    when "planned"
      "text-bg-primary"
    end
  end
end
