# frozen_string_literal: true

class DeviceSlot < ApplicationRecord
  belongs_to :record, polymorphic: true

  validates :name, presence: true
end
