# frozen_string_literal: true

require "rails_helper"

RSpec.describe Move::ConnectionPolicy, type: :policy do
  let(:move_connection) { move_connections(:one) }
  let(:context) { { user: user } }
  let(:policy) { described_class.new(move_connection, user: user) }

  it_behaves_like "with default index policy"
  it_behaves_like "with default manage policy"

  describe_rule :create? do
    context "when user is admin" do
      failed "when move is executed" do
        before { move_connection.move = moves(:executed) }

        let(:user) { users(:admin) }
      end

      succeed "when move is not executed" do
        let(:user) { users(:admin) }
      end
    end

    context "when user is not admin" do
      failed "when a reader user asks" do
        let(:user) { users(:reader) }
      end

      succeed "when a writer user asks" do
        let(:user) { users(:writer) }
      end
    end
  end
end
