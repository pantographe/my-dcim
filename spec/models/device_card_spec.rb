# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceCard do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:device_card) do
    described_class.new(name: "1", slot: device_slots(:device_model_slot))
  end

  describe "associations" do
    it { is_expected.to belong_to(:slot) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end
end
