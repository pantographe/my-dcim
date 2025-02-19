# frozen_string_literal: true

class ExternalAppRecordsProcessor < ApplicationProcessor
  include Sortable
  SORTABLE_FIELDS = %w[
    server_id server.name server.numero external_name external_id external_serial frame.name
  ].freeze

  map :frame_ids, filter_with: :non_empty_array do |frame_ids:|
    raw.joins(:frame).where(frame: { id: frame_ids })
  end

  match :external_serial_status, fail_when_no_matches: true do
    having "found" do
      raw.where.not(external_serial: nil).where.not(external_serial: "")
    end

    having "not_found" do
      raw.where(external_serial: nil).or(raw.where(external_serial: ""))
    end
  end

  sortable fields: SORTABLE_FIELDS
end
