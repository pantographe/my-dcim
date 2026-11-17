# frozen_string_literal: true

class CardMigration < ActiveRecord::Base
  self.table_name = "cards"
end

class PortMigration < ActiveRecord::Base
  self.table_name = "ports"

  def card
    raise if attachable_type != "Card"

    CardMigration.find attachable_id
  end
end

class MovesProjectStepMigration < ActiveRecord::Base
  self.table_name = "moves_project_steps"

  has_many :moves, class_name: "MoveMigration", inverse_of: :moves_project_step_id
end

class MoveMigration < ActiveRecord::Base
  self.table_name = "moves"

  belongs_to :moves_project_step, class_name: "MovesProjectStepMigration"
end

class MoveConnectionMigration < ActiveRecord::Base
  self.table_name = "move_connections"

  belongs_to :move, class_name: "MoveMigration"
  belongs_to :moves_project_step, class_name: "MovesProjectStepMigration"
  belongs_to :port_from, class_name: "PortMigration"
end

class MakeMoveConnectionAttchedToStepInsteadOfMove < ActiveRecord::Migration[8.1]
  def change
    add_reference :move_connections, :moves_project_step, null: true, foreign_key: true

    reversible do |direction|
      direction.up do
        MoveConnectionMigration.reset_column_information
        MoveConnectionMigration.find_each do |move_connection|
          move_connection.moves_project_step_id = move_connection.move.moves_project_step_id
          move_connection.save!
        end

        change_column_null :move_connections, :moves_project_step_id, false
      end

      direction.down do
        MoveConnectionMigration.reset_column_information
        MoveConnectionMigration.find_each do |move_connection|
          port_from = move_connection.port_from
          card = port_from.card
          move_connection.move = MoveMigration.find_by(
            moves_project_step_id: move_connection.moves_project_step_id,
            moveable_type: "Server",
            moveable_id: card.server_id
          )

          move_connection.save!
        end

        change_column_null :move_connections, :move_id, false
      end
    end

    remove_column :move_connections, :move_id, :integer, null: true
  end
end
