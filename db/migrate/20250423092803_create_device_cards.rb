# frozen_string_literal: true

class CreateDeviceCards < ActiveRecord::Migration[8.0]
  def change
    create_table :device_cards do |t|
      t.references :device_slot, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
