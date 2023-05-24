# frozen_string_literal: true

class MemoryComponent < ApplicationRecord
  belongs_to :server, optional: true
  belongs_to :memory_type, optional: true

  def to_s
    "#{quantity} x #{memory_type}"
  end
end
