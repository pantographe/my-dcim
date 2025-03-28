# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServersProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Server.all }
  let(:params) { {} }

  let(:attributes) do
    {
      frame: frames(:one), gestion: gestions(:one), domaine: domaines(:switch), modele: modeles(:one),
      cluster: clusters(:cloud_c1), stack: stacks(:red)
    }
  end

  describe "when searching" do
    let(:params) { { q: "wood" } }

    before do
      Server.create!(name: "brick", numero: 1, **attributes)
      Server.create!(name: "wood", numero: 2, **attributes)
      Server.create!(name: "wooden", numero: 3, **attributes)
    end

    # IMPROVE
    it { expect(result.size).to eq(2) }
  end

  describe "when filtering by frame_ids" do
    let(:frame)  { Frame.create!(name: "A1", bay: bays(:one)) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one frame_id" do
      let(:params) { { frame_ids: frame.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many frame_ids" do
      let(:frame_second) { Frame.create!(name: "A2", bay: bays(:one)) }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, frame: frame_second) }

      let(:params) { { frame_ids: [frame.id, frame_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by bay_ids" do
    let(:bay)    { Bay.create!(name: "A1", islet: islets(:one), bay_type: bay_types(:one)) }
    let(:frame)  { Frame.create!(name: "F1", bay:) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one bay_ids" do
      let(:params) { { bay_ids: bay.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many bay_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:bay_second)   { Bay.create!(name: "A2", islet: islets(:one), bay_type: bay_types(:one)) }
      let(:frame_second) { Frame.create!(name: "F2", bay:) }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, frame: frame_second) }

      let(:params) { { bay_ids: [bay.id, bay_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by islet_ids" do
    let(:islet)  { Islet.create!(name: "I1", site: sites(:one)) }
    let(:bay)    { Bay.create!(name: "A1", islet: islet, bay_type: bay_types(:one)) }
    let(:frame)  { Frame.create!(name: "F1", bay:) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one islet_ids" do
      let(:params) { { islet_ids: islet.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many islet_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:islet_second) { Islet.create!(name: "I2", site: sites(:one)) }
      let(:bay_second)   { Bay.create!(name: "A2", islet: islet_second, bay_type: bay_types(:one)) }
      let(:frame_second) { Frame.create!(name: "F2", bay: bay_second) }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, frame: frame_second) }

      let(:params) { { islet_ids: [islet.id, islet_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:room)   { Room.create(name: "R1", site: sites(:one)) }
    let(:islet)  { Islet.create!(name: "I1", room:) }
    let(:bay)    { Bay.create!(name: "A1", islet: islet, bay_type: bay_types(:one)) }
    let(:frame)  { Frame.create!(name: "A1", bay:) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, frame:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:params) { { room_ids: room.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many room_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:room_second)  { Room.create(name: "R2", site: sites(:one)) }
      let(:islet_second) { Islet.create!(name: "I2", room: room_second) }
      let(:bay_second)   { Bay.create!(name: "A2", islet: islet_second, bay_type: bay_types(:one)) }
      let(:frame_second) { Frame.create!(name: "F2", bay: bay_second) }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, frame: frame_second) }

      let(:params) { { room_ids: [room.id, room_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by modele_ids" do
    let(:modele) do
      Modele.create!(name: "M1", manufacturer: manufacturers(:fortinet), architecture: architectures(:rackable),
                     category: categories(:one))
    end

    let(:server) { Server.create!(name: "server", numero: 1, **attributes, modele:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one room_ids" do
      let(:params) { { modele_ids: modele.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many room_ids" do
      let(:modele_second) do
        Modele.create!(name: "M2", manufacturer: manufacturers(:fortinet), architecture: architectures(:rackable),
                       category: categories(:one))
      end
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, modele:) }

      let(:params) { { modele_ids: [modele.id, modele_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by gestion_ids" do
    let(:gestion) { Gestion.create!(name: "G1") }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, gestion:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one gestion_ids" do
      let(:params) { { gestion_ids: gestion.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many gestion_ids" do
      let(:gestion_second) { Gestion.create!(name: "G2") }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, gestion: gestion_second) }

      let(:params) { { gestion_ids: [gestion.id, gestion_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by domaine_ids" do
    let(:domaine) { Domaine.create!(name: "D1") }
    let(:server)  { Server.create!(name: "server", numero: 1, **attributes, domaine:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one domaine_ids" do
      let(:params) { { domaine_ids: domaine.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many domaine_ids" do
      let(:domaine_second) { Domaine.create!(name: "D2") }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, domaine: domaine_second) }

      let(:params) { { domaine_ids: [domaine.id, domaine_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by cluster_ids" do
    let(:cluster) { Cluster.create!(name: "C1") }
    let(:server)  { Server.create!(name: "server", numero: 1, **attributes, cluster:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one cluster_ids" do
      let(:params) { { cluster_ids: cluster.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many cluster_ids" do
      let(:cluster_second) { Cluster.create!(name: "C2") }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, cluster: cluster_second) }

      let(:params) { { cluster_ids: [cluster.id, cluster_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by stack_ids" do
    let(:stack) { Stack.create!(name: "S1") }
    let(:server)  { Server.create!(name: "server", numero: 1, **attributes, stack:) }

    before do
      server
      Server.create!(name: "server2", numero: 2, **attributes)
    end

    context "with one stack_ids" do
      let(:params) { { stack_ids: stack.id } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many stack_ids" do
      let(:stack_second) { Stack.create!(name: "S2") }
      let(:another_server) { Server.create!(name: "server3", numero: 3, **attributes, stack: stack_second) }

      let(:params) { { stack_ids: [stack.id, stack_second.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when filtering by category_id" do
    let(:category) { Category.create! }
    let(:modele) { Modele.create!(name: "Mod", description: "Mod desc", category:, manufacturer: Manufacturer.create!, architecture: Architecture.create!) }
    let(:server) { Server.create!(name: "server", numero: 1, **attributes, modele:) }

    before do
      server
    end

    context "with one category_id" do
      let(:params) { { category_ids: [category.id] } }

      it { expect(result.size).to eq(1) }
      it { is_expected.to contain_exactly(server) }
    end

    context "with many category_ids" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:another_category) { Category.create! }
      let(:another_modele) { Modele.create!(name: "Mod2", description: "Mod2 desc", category: another_category, manufacturer: Manufacturer.create!, architecture: Architecture.create!) }
      let(:another_server) { Server.create!(name: "server2", numero: 2, **attributes, modele: another_modele) }

      let(:params) { { category_ids: [category.id, another_category.id] } }

      before do
        another_server
      end

      it { expect(result.size).to eq(2) }
      it { is_expected.to contain_exactly(server, another_server) }
    end
  end

  describe "when sorting" do
    pending "TODO"
  end

  describe "When searching on every fields" do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:room)     { Room.create(name: "R1", site: sites(:one)) }
    let(:islet)    { Islet.create!(name: "I1", room:) }
    let(:bay)      { Bay.create!(name: "A1", islet:, bay_type: bay_types(:one)) }
    let(:frame)    { Frame.create!(name: "A1", bay:) }
    let(:category) { Category.create! }
    let(:modele)   { Modele.create!(name: "Mod", description: "Mod desc", category:, manufacturer: Manufacturer.create!, architecture: Architecture.create!) }
    let(:gestion)  { Gestion.create!(name: "G1") }
    let(:domaine)  { Domaine.create!(name: "D1") }
    let(:cluster)  { Cluster.create!(name: "C1") }
    let(:stack)    { Stack.create!(name: "S1") }

    let(:server) do
      Server.create!(name: "wood", numero: 1, **attributes, frame:, modele:, gestion:, domaine:, cluster:, stack:)
    end

    let(:params) do
      {
        q: "wood", frame_ids: frame.id, bay_ids: bay.id, islet_ids: islet.id, room_ids: room.id, modele_ids: modele.id,
        gestion_ids: gestion.id, domaine_ids: domaine.id, cluster_ids: cluster.id, stack_ids: stack.id,
        category_ids: category.id
      }
    end

    before { server }

    it { expect(result.size).to eq(1) }
    it { is_expected.to contain_exactly(server) }

    described_class::SORTABLE_FIELDS.each do |field|
      context "and sort on #{field}" do # rubocop:disable RSpec/ContextWording, RSpec/MultipleMemoizedHelpers
        let(:params) do
          {
            q: "wood", frame_ids: frame.id, bay_ids: bay.id, islet_ids: islet.id, room_ids: room.id, modele_ids: modele.id,
            gestion_ids: gestion.id, domaine_ids: domaine.id, cluster_ids: cluster.id, stack_ids: stack.id,
            category_ids: category.id, sort_by: field
          }
        end

        it { expect(result.size).to eq(1) }
        it { is_expected.to contain_exactly(server) }
      end
    end
  end
end
