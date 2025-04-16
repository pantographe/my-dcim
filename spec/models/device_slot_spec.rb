# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceSlot do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:device_slot) do
    described_class.new(name: "1", record: device_models(:one))
  end

  describe "associations" do
    it { is_expected.to belong_to(:record) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end
end
