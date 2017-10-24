class MovedConnection < ApplicationRecord

  belongs_to :port_from, class_name: 'Port'
  belongs_to :port_to, class_name: 'Port'

  validates_presence_of :port_from_id, :port_to_id

  def ports
    [self.port_from, self.port_to]
  end
  
  def cablecolor
    color
  end

  def self.per_servers(servers)
    servers_ports_ids = servers.map(&:ports).flatten.map(&:id)
    MovedConnection.where('port_from_id IN (?) OR port_to_id IN (?)', servers_ports_ids, servers_ports_ids)
  end

end