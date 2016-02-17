class AddMissingFieldsToServeurs < ActiveRecord::Migration
  def change
    add_column :serveurs, :pdu_ondule, :string
    add_column :serveurs, :pdu_normal, :string
    add_column :serveurs, :baie, :integer
    add_column :serveurs, :id_baie, :string
    add_column :serveurs, :fc_calcule, :integer
    add_column :serveurs, :fc_futur, :integer
    add_column :serveurs, :i, :string
    add_column :serveurs, :rj45_calcule, :integer
    add_column :serveurs, :tenGbps_futur, :integer
    add_column :serveurs, :ip, :string
    add_column :serveurs, :hostname, :string
    add_column :serveurs, :etat_conf_reseau, :string
    add_column :serveurs, :action_conf_reseau, :string
  end
end