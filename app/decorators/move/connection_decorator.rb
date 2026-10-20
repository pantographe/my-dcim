# frozen_string_literal: true

class Move
  class ConnectionDecorator < ApplicationDecorator
    ACTION_BADGE_COLORS = { destroy: :danger, update: :warning, create: :success }.freeze

    def status_to_badge_component
      color = executed_at.nil? ? :primary : :success
      locale_key = executed_at.nil? ? :planned : :executed
      text = Move::Connection.human_attribute_name("status.#{locale_key}")

      BadgeComponent.new(text, color:, variant: :pill)
    end

    def description
      I18n.t("move_connections_decorator.description",
             port_from_server: port_from.server.decorated.full_name,
             port_from_id:,
             port_to_server: port_to&.server&.decorated&.full_name, # rubocop:disable Style/SafeNavigationChainLength
             port_to_id:,
             vlans:,
             cable_name:,
             cable_color:)
    end

    def display_name
      description
    end

    def action
      @action ||= if port_to_id.nil?
                    :destroy
                  elsif port_from.connections.any?
                    :update
                  else
                    :create
                  end
    end

    def extra_connection_destroyed?
      @extra_connection_destroyed ||= port_to&.connections&.any? || false
    end

    def action_badge_color
      ACTION_BADGE_COLORS[action]
    end
  end
end
