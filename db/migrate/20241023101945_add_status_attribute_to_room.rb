# frozen_string_literal: true

class AddStatusAttributeToRoom < ActiveRecord::Migration[7.2]
  def change
    add_column :rooms, :status, :string
  end
end
