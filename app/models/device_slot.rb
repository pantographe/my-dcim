# frozen_string_literal: true

class DeviceSlot < ApplicationRecord
  belongs_to :record, polymorphic: true # TODO: rename as owner?

  # TODO: maybe put this relation in slot as belongs_to too as attachable
  has_one :card, class_name: "DeviceCard", dependent: :restrict_with_error

  validates :name, presence: true
end
