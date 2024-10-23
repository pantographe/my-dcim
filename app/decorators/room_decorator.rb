# frozen_string_literal: true

class RoomDecorator < ApplicationDecorator
  class << self
    def status_for_options
      Room.statuses.keys.map { |status| [Room.human_attribute_name("status.#{status}"), status] }
    end
  end
end
