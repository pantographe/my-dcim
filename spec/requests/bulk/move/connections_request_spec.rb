# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/moves/:move_id/connections" do
  before { sign_in users(:admin) }

  describe "DELETE /destroy" do
    subject(:response) do
      delete bulk_move_connections_path(move_id, ids:)

      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:move_id) { moves(:one).id }
    let(:ids) { [move_connections(:one).id, move_connections(:three).id] }

    context "with non existing move" do
      let(:move_id) { 999 }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with move connections not belonging to move" do
      let(:ids) { [move_connections(:two).id] }

      it { expect { response }.not_to change(Move::Connection, :count) }
    end

    context "with move connections with no associations" do
      it { expect { response }.to change(Move::Connection, :count).by(-2) }
      it { expect(response).to redirect_to(move_connections_path(move_id:)) }
    end
  end
end
