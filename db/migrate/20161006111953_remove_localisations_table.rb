class RemoveLocalisationsTable < ActiveRecord::Migration
  def up
    drop_table :localisations
    remove_column :servers, :localisation_id
  end
  def down
    create_table :localisations do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
    add_column :servers, :localisation_id, :integer
  end
end
