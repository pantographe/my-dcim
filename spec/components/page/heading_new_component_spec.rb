# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page::HeadingNewComponent, type: :component do
  let(:title) { "Title" }
  let(:breadcrumb_steps) { { "Sites" => "#url_sites" } }
  let(:resource) { sites(:one) }
  let(:component) { described_class.new(resource:, title:, breadcrumb_steps:) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) { nil }

  it "renders a back button" do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component).to have_tag("div.col-12.bg-body") do
      with_tag("div.back-button-container") do
        with_tag("a.btn.back-button", title: I18n.t("action.back"), href: "http://test.host/sites") do
          with_tag("i.bi-chevron-left")
          with_tag("span.ms-2", text: I18n.t("action.back"))
        end
      end

      with_tag("div.d-flex") do
        with_tag("h1", text: "Title")
      end
    end
  end
end
