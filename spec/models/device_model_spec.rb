# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceModel do
  # it_behaves_like "changelogable", new_attributes: {  }

  subject(:device_model) do
    described_class.new(
      name: "Express5800 - 120RG-2", category: categories(:one), architecture: architectures(:rackable),
      manufacturer: manufacturers(:fortinet)
    )
  end

  describe "associations" do
    it { is_expected.to belong_to(:manufacturer) }
    it { is_expected.to belong_to(:architecture) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:slots) }
  end

  describe "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#validate_network_types_values" do
    let(:device_model) { device_models(:one) }

    context "when network_types is empty (valid)" do
      it { expect(device_model).to be_valid }
    end

    context "when network_types is filled with valid values (valid)" do
      before { device_model.update(network_types: Modele::Network::TYPES.sample(1)) } # TODO: rename

      it { expect(device_model).to be_valid }
    end

    context "when network_types is filled with unvalid values (unvalid)" do
      before do
        device_model.network_types = ["not_valid_value"]
        device_model.validate
      end

      it { expect(device_model).not_to be_valid }
      it { expect(device_model.errors.key?(:network_types)).to be(true) }
    end
  end

  describe "#to_s" do
    it { expect(device_model.to_s).to eq device_model.name }
  end

  describe "#should_generate_new_friendly_id?" do
    pending
  end

  describe "#deep_dup" do
    subject(:device_model) { device_models(:one) }

    it { expect(device_model.deep_dup).not_to eq(device_model) }
    it { expect(device_model.deep_dup.name).to eq(device_model.name) }
    it { expect(device_model.deep_dup.slots.first.name).to eq(device_model.slots.first.name) }
    it { expect(device_model.deep_dup.slots.first.position).to eq(device_model.slots.first.position) }
  end
end
