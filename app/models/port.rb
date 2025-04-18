# frozen_string_literal: true

require "csv"

class Port < ApplicationRecord
  has_changelog

  belongs_to :card
  delegate :is_power_input?, to: :card, :allow_nil => true

  has_one :connection
  delegate :paired_connection, to: :connection, allow_nil: true

  has_one :cable, through: :connection
  delegate :color, to: :cable, prefix: true, allow_nil: true
  delegate :name, to: :cable, prefix: true, allow_nil: true
  has_one :server, through: :card, touch: true
  delegate :server_id, to: :card, prefix: false

  scope :sorted, -> { order(:position) }

  def network_conf(switch_slot)
    cable_name = connection.try(:cable).try(:name)
    if cable_name.present?
      "#{connection.cable.try(:color)} - #{cable_name} - Switch #{cable_name[0]} - Port #{switch_slot}:#{cable_name[1..]} - #{vlans}"
    end
  end

  def connect_to_port(other_port, cable_name, cable_color, vlans, special_case = nil, comments = nil)
    remove_unused_connections([self, other_port])
    if other_port
      cable = nil
      if connection.present?
        cable ||= connection.cable
      end
      if other_port.connection.present?
        cable ||= other_port.connection.cable
      end
      if cable.present? && !cable.destroyed?
        cable.name = cable_name
        cable.color = cable_color
        cable.special_case = special_case
        cable.comments = comments
        cable.save
      else
        cable = Cable.create(name: cable_name, color: cable_color)
      end

      self.connection = Connection.find_or_create_by(port: self, cable: cable)
      other_port.connection = Connection.find_or_create_by(port: other_port, cable: cable)
      self.vlans = vlans
      other_port.vlans = self.vlans

      save && other_port.save
    end
  end

  def self.to_txt(frames)
    txt = []
    if frames.present?
      frames.each do |frame|
        txt << "\r\n#{frame.name_with_room_and_islet}\r\n"
        txt << "---------------\r\n"
        frame.servers.includes(:modele, :cards => %i[ports composant]).order('position desc').each do |server|
          txt << "#{server.name} (#{server.modele.try(:name)})\r\n"
          server.cards.each do |card|
            card.ports.each do |port|
              if port&.cable_name && card.composant.name.present?
                txt << "    * #{card.composant.name}#{card.composant.name.include?("SL") ? "/#{port.position}" : port.position} - #{port.network_conf(server.frame.switch_slot)}\r\n"
              end
            end
          end
        end
      end
    end
    txt.join
  end

  def self.to_csv(frames)
    attributes = %w[name_with_room_and_islet server_slug server_name server_modele port_info]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      frames.each do |frame|
        frame.servers.includes(:modele, :cards => %i[ports composant]).order('position desc').each do |server|
          frame_server_info = [frame.name_with_room_and_islet, server.slug, server.name, server.modele.try(:name)]
          used_port_present = false
          server.cards.each do |card|
            card.ports.each do |port|
              if port&.cable_name && card.composant.name.present?
                used_port_present = true
                csv << (frame_server_info + ["#{card.composant.name}#{card.composant.name.include?("SL") ? "/#{port.position}" : port.position} - #{port.network_conf(server.frame.switch_slot)}"])
              end
            end
          end
          # Print one time the server if no port used
          if used_port_present == false
            csv << (frame_server_info + [nil])
          end
        end
      end
    end
  end

  private

  def remove_unused_connections(ports)
    ports.compact_blank.each do |port|
      old_port_destination = port.paired_connection.try(:port)
      if old_port_destination.present? && ports.exclude?(old_port_destination)
        old_port_destination.connection.cable.destroy
      end
    end
  end
end
