# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rooms" do
  let(:room) { rooms(:one) }

  describe "GET #new" do
    subject(:response) do
      get new_room_path

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "POST #create" do
    subject(:response) do
      post(rooms_path, params:)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { room: { name: "Room 1", site_id: sites(:one).id } } }

    include_context "with authenticated user"
    it_behaves_like "with create another one"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(room_path(assigns(:room))) }
      it { expect { response }.to change(Room, :count).by(1) }
    end

    context "with invalid parameters" do
      let(:params) { { room: { name: "Room 1", site_id: 9999 } } }

      it { expect(response).to render_template(:new) }
      it { expect { response }.not_to change(Room, :count) }
    end

    context "without attributes" do
      let(:params) { { frame: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #print" do
    subject(:response) do
      get print_visualization_room_path(room)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    context "with not found room" do
      let(:room) { Room.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing room" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:print) }
      it { expect(response).to render_template("layouts/pdf") }
    end
  end
end
