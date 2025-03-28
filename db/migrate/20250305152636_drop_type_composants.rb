# frozen_string_literal: true

class MigrationTypeComposant < ActiveRecord::Base
  self.table_name = :type_composants
end

class MigrationComposant < ActiveRecord::Base
  self.table_name = :composants

  belongs_to :type_composant, class_name: "MigrationTypeComposant"
end

class DropTypeComposants < ActiveRecord::Migration[8.0]
  def change
    up_only do
      MigrationComposant.where.not(type_composant: MigrationTypeComposant.find_by(name: "SLOT")).destroy_all
    end

    revert do
      create_table :type_composants do |t| # rubocop:disable Rails/CreateTableWithTimestamps
        t.string :name
      end

      add_reference :composants, :type_composant, foreign_key: true
    end
  end
end
