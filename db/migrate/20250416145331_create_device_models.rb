# frozen_string_literal: true

class CreateDeviceModels < ActiveRecord::Migration[8.0]
  def change
    create_table :device_models do |t|
      t.references :category, null: false, foreign_key: true
      t.references :architecture, null: false, foreign_key: true
      t.references :manufacturer, null: false, foreign_key: true
      t.string :slug
      t.string :name, null: false
      t.text :description
      t.string :color
      t.integer :u
      t.string :network_types, default: [], array: true, null: false

      t.timestamps
    end
  end
end
