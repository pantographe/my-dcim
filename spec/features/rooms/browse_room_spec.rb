# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rooms::BrowseRoom", :js do
  let(:room) { rooms(:one) }

  # The 2nd bay created an empty "couple div" in rooms #Show view, causing the test to fail.
  before do
    room.islets.first.bays.last.destroy!
  end

  it("browse a room, islets and bays, change view and background color") do # rubocop:disable RSpec/MultipleExpectations
    sign_in(users(:one))

    visit room_path(room)
    expect(page).to have_current_path(room_path(room))

    frame = room.frames.first

    # 1. Select a frame
    overview_frame = find("div[data-frame-id=#{frame.slug}]")
    overview_frame.click

    # Waits for the overview to fully load
    find("div##{room.name.downcase}")

    frame.servers.each do |server|
      expect(page).to have_content(server.name)
    end

    # 2. Change view to 'back'
    switch_view_btn = find("span.pull-right > a.btn.btn-success")
    switch_view_btn.click

    # Since the overview container is already loaded, we cannot use find() to wait for loading
    sleep 1

    # On the back view, we should see some server cards (only the 2nd server has cards)
    frame.servers.second.cards.pluck(:name).each do |card_name|
      expect(page).to have_content(card_name)
    end

    # Modele background color
    overview_frame_title = find("div.title > a[data-frame-id=#{frame.slug}]")
    overview_frame_title.click

    sleep 1

    # For background color set to 'modele', we check for a cyan/white background-color
    colored_lines = all("ul.servers > li.server.mystring")

    colored_lines.each do |line|
      expect(line.style("background-color")["background-color"]).to eq("rgb(183, 247, 255)").or eq("rgb(255, 255, 255)")
    end

    # 3. Change background color to 'gestionnaire'
    bg_dropdown_button = first("span.pull-right > * > .btn-default.dropdown-toggle")
    bg_dropdown_button.click

    bg_dropdown_gestionnaire = all(".dropdown-menu > li")[1]
    bg_dropdown_gestionnaire.click

    sleep 1

    # For background color set to 'gestionnaire', we check for a green/white background-color
    colored_lines = all("ul.servers > li.server.mystring")

    colored_lines.each do |line|
      expect(line.style("background-color")["background-color"]).to eq("rgb(118, 255, 160)").or eq("rgb(255, 255, 255)")
    end
  end
end
