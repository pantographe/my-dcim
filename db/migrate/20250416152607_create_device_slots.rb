# frozen_string_literal: true

class CreateDeviceSlots < ActiveRecord::Migration[8.0]
  def change
    create_table :device_slots do |t|
      t.references :record, polymorphic: true, null: false
      t.string :name, null: false
      t.integer :position

      t.timestamps
    end
  end
end
