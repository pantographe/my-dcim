# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomDecorator, type: :decorator do
  describe ".status_for_options" do
    it { expect(described_class.status_for_options.pluck(1)).to match_array(Room.statuses.keys) }
  end
end
