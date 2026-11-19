# frozen_string_literal: true

class Move
  class Connection < ApplicationRecord
    has_changelog

    belongs_to :step, class_name: "MovesProjectStep", foreign_key: :moves_project_step_id, inverse_of: :move_connections
    belongs_to :port_from, class_name: "Port"
    belongs_to :port_to, class_name: "Port", optional: true

    scope :not_executed, -> { where(executed_at: nil) }

    validates :port_from_id, uniqueness: { scope: %i[moves_project_step_id] }

    def ports
      [port_from, port_to].compact
    end

    def execute!
      return if executed?

      transaction(requires_new: true) do
        port_from.connect_to_port(port_to, cable_name, cable_color, vlans)

        update!(executed_at: Time.zone.now)
      end
    end

    def executed?
      executed_at?
    end

    def associated_move
      return nil unless port_from

      step.moves.where(moveable: port_from.attached)
    end
  end
end
