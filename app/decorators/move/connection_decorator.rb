# frozen_string_literal: true

class Move
  class ConnectionDecorator < ApplicationDecorator
    def status_to_badge_component
      color = executed_at.nil? ? :primary : :success
      trad_value = executed_at.nil? ? :planned : :executed
      text = Move::Connection.human_attribute_name("status.#{trad_value}")

      BadgeComponent.new(text, color:, variant: :pill)
    end
  end
end
