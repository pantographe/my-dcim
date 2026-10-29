# frozen_string_literal: true

class AddIsExistingConnectionRemovalBatchToMoveConnections < ActiveRecord::Migration[8.1]
  def change
    add_column :move_connections, :is_existing_connection_removal_batch, :boolean, null: false, default: false
  end
end
