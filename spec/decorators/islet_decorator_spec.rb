# frozen_string_literal: true

require "rails_helper"

RSpec.describe IsletDecorator, type: :decorator do
  describe ".grouped_by_sites_options_for_select" do
    let(:expected_response) do
      {
        "Site 1" => [["S1 Ilot Islet1", 1], ["S1 Ilot Islet2", 2]]
      }
    end

    it { expect(described_class.grouped_by_sites_options_for_select).to match(expected_response) }
  end

  describe ".cooling_modes_for_options" do
    it { expect(described_class.cooling_modes_for_options.pluck(1)).to match_array(Islet.cooling_modes.keys) }
  end
end
