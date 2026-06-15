# frozen_string_literal: true

class Circuit < ApplicationRecord
  has_changelog

  belongs_to :record, polymorphic: true
end
