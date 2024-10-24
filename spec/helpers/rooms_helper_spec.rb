# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomsHelper do
  describe "#surface_area_with_suffix" do
    it { expect(helper.surface_area_with_suffix(300)).to eq("300 m²") }
  end
end
