# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page::HeadingShowComponent, type: :component do
  let(:title) { "Title" }
  let(:breadcrumb_steps) { { "Sites" => "#url_sites" } }
  let(:resource) { sites(:one) }
  let(:component) { described_class.new(resource:, title:, breadcrumb_steps:) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) { nil }

  context "without extra_buttons" do
    it "renders left_content with a back button" do # rubocop:disable RSpec/ExampleLength
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

    it "renders right_content with an edit button" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          with_tag("div.align-self-center.d-inline-flex") do
            with_tag("a.btn-info", title: I18n.t("action.edit"), href: "http://test.host/sites/1/edit") do
              with_tag("i.bi-pencil")
              with_tag("span.ms-2.d-none", text: I18n.t("action.edit"))
            end
          end
        end
      end
    end
  end

  context "with extra_buttons" do
    let(:block) do
      proc do |heading|
        heading.with_extra_buttons do
          "<a href=\"#\" class=\"btn\">Button</a>".html_safe
        end
      end
    end

    it "renders right_content with an extra_button and an edit button" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          with_tag("a.btn", text: "Button")
          with_tag("div.align-self-center.d-inline-flex") do
            with_tag("a.btn-info", title: I18n.t("action.edit"), href: "http://test.host/sites/1/edit") do
              with_tag("i.bi-pencil")
              with_tag("span.ms-2.d-none", text: I18n.t("action.edit"))
            end
          end
        end
      end
    end
  end
end
