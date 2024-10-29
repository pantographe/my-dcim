# frozen_string_literal: true

require "rails_helper"

RSpec.describe SitesHelper do
  describe "delivery_map_accepted_mime_types" do
    it { expect(helper.delivery_map_accepted_mime_types).to eq("image/png, image/jpeg, image/gif, application/pdf") }
  end
end
