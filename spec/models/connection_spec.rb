# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Connection, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:cable) }
    it { is_expected.to belong_to(:port).optional(true) }
  end

  describe "#paired_connection" do
    pending
  end
end
