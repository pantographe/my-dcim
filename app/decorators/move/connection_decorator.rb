# frozen_string_literal: true

class Move
  class ConnectionDecorator < ApplicationDecorator
    def status_to_badge_component
      trad_value = executed_at.nil? ? :planned : :executed
      color = executed_at.nil? ? :primary : :success
      text = I18n.t(".activerecord.attributes.move/connection.statuses.#{trad_value}")

      BadgeComponent.new(text, color:, variant: :pill)
    end
  end
end
