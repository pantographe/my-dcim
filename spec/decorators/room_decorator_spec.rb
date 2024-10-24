# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoomDecorator, type: :decorator do
  describe ".statuses_for_options" do
    it { expect(described_class.statuses_for_options.pluck(1)).to match_array(Room.statuses.keys) }
  end

  describe "#badge_color_for_status" do
    let(:subject) { rooms(:one).decorated }

    context "with status = active" do
      it { expect(subject.badge_color_for_status).to eq "text-bg-success" }
    end

    context "with status = passive" do
      before { rooms(:one).status = :passive }

      it { expect(subject.badge_color_for_status).to eq "text-bg-warning" }
    end

    context "with status = planned" do
      before { rooms(:one).status = :planned }

      it { expect(subject.badge_color_for_status).to eq "text-bg-primary" }
    end

    context "with status = unknown" do
      before { rooms(:one).status = :unknown }

      it { expect(subject.badge_color_for_status).to be_nil }
    end
  end
end
