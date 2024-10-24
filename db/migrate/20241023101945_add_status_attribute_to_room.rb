# frozen_string_literal: true

class MigrationRoom < ActiveRecord::Base
  self.table_name = :rooms
end

class AddStatusAttributeToRoom < ActiveRecord::Migration[7.2]
  def change
    add_column :rooms, :status, :integer

    up_only do
      MigrationRoom.find_each do |room|
        status = room.display_on_home_page ? 0 : 1
        room.update(status: status)
      end

      change_column_null(:rooms, :status, false)
    end
  end
end