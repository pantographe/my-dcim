# frozen_string_literal: true

class DeviceModel < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog

  belongs_to :category # TODO: counter_cache: true
  belongs_to :architecture # TODO: counter_cache: true
  belongs_to :manufacturer # TODO: counter_cache: true

  has_many :slots, class_name: "DeviceSlot", as: :record, dependent: :destroy

  validates :name, presence: true
  validate :validate_network_types_values
  normalizes :network_types, with: ->(values) { values.compact_blank }

  delegate :to_s, to: :name

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def deep_dup
    dup.tap do |device_modele|
      device_modele.slots = slots.map(&:deep_dup)
    end
  end

  private

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end

  def validate_network_types_values
    return if network_types.empty?
    return if network_types.any? { |n| Modele::Network::TYPES.include?(n) } # TODO: rename

    errors.add(:network_types, :invalid)
  end
end
