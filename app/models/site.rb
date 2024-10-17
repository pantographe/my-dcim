# frozen_string_literal: true

class Site < ApplicationRecord
  geocoded_by :address
  has_changelog

  has_many :rooms, dependent: :restrict_with_error
  has_many :frames, through: :rooms, dependent: :restrict_with_error

  after_validation :geocode

  scope :sorted, -> { order(:position) }
  scope :visible_on_home_page, -> { where(display_on_home_page: true) }

  def to_s
    name
  end

  def address
    [street, city, country].compact.join(', ')
  end
end
