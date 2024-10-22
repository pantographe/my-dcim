# frozen_string_literal: true

class Site < ApplicationRecord
  has_changelog

  has_many :rooms, dependent: :restrict_with_error
  has_many :frames, through: :rooms, dependent: :restrict_with_error

  has_one_attached :delivery_map

  validates :delivery_map, content_type: [:png, :jpg, :jpeg, :pdf, :gif]

  geocoded_by :address
  after_validation :geocode

  scope :sorted, -> { order(:position) }

  def to_s
    name
  end

  def address
    [street, city, country].compact.join(', ')
  end
end
