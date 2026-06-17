# frozen_string_literal: true

class Move
  class ConnectionsProcessor < ApplicationProcessor
    include Sortable

    SORTABLE_FIELDS = %w[cable_name].freeze

    sortable fields: SORTABLE_FIELDS
  end
end
