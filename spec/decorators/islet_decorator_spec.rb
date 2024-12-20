# frozen_string_literal: true

require "rails_helper"

RSpec.describe IsletDecorator, type: :decorator do
  let(:islet) { islets(:one) }
  let(:decorated_islet) { islet.decorated }

  describe ".grouped_by_sites_options_for_select" do
    let(:expected_response) do
      {
        "Site 1" => [["S1 Ilot Islet1", 1], ["S1 Ilot Islet2", 2]]
      }
    end

    it { expect(described_class.grouped_by_sites_options_for_select).to match(expected_response) }
  end

  describe ".cooling_modes_options_for_select" do
    it { expect(described_class.cooling_modes_options_for_select.pluck(1)).to match_array(Islet.cooling_modes.keys) }
  end

  describe ".access_control_options_for_select" do
    it { expect(described_class.access_control_options_for_select.pluck(1)).to match_array(Islet.access_controls.keys) }
  end

  describe "#cooling_mode_to_human" do
    subject(:cooling_mode_sentence) { decorated_islet.cooling_mode_to_human }

    context "with no cooling mode" do
      it { is_expected.to eq("Pas de confinement") }
    end

    context "with cooling mode set" do
      before { islet.cooling_mode = "hot_containment" }

      it { is_expected.to eq("Confinement chaud") }
    end
  end

  describe "#access_control_to_human" do
    subject(:access_control_sentence) { decorated_islet.access_control_to_human }

    context "with no access control" do
      it { is_expected.to eq("Pas de contrôle") }
    end

    context "with access control set" do
      before { islet.access_control = "key" }

      it { is_expected.to eq("Clé") }
    end
  end
end