# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bay do
  # it_behaves_like "changelogable", new_attributes: { name: "New name" }

  describe "associations" do
    it { is_expected.to belong_to(:bay_type) }
    it { is_expected.to belong_to(:islet) }
    it { is_expected.to belong_to(:manufacturer).optional }
    it { is_expected.to have_one(:room).through(:islet) }
    it { is_expected.to have_many(:frames) }
    it { is_expected.to have_many(:materials).through(:frames) }
  end

  describe "validations" do
    it { is_expected.to define_enum_for(:access_control).with_values(%i[badge key locken_key]) }
  end

  describe "#to_s" do
    pending
  end

  describe "#detailed_name" do
    pending
  end

  describe "#list_frames" do
    pending
  end
end
