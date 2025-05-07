# frozen_string_literal: true

class DeviceCard < ApplicationRecord
  belongs_to :slot, class_name: "DeviceSlot", foreign_key: :device_slot_id, inverse_of: :card

  validates :name, presence: true
end
