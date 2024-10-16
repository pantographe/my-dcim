# frozen_string_literal: true

require "rails_helper"

RSpec.describe Page::HeadingEditComponent, type: :component do
  let(:title) { "Title" }
  let(:breadcrumb_steps) { { "Sites" => "#url_sites" } }
  let(:resource) { sites(:one) }
  let(:component) { described_class.new(resource:, title:, breadcrumb_steps:) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:block) { nil }

  context "without extra_buttons" do
    it "renders left_content with a back button" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          with_tag("a.btn-default", title: "Retour", href: "http://test.host/sites") do
            with_tag("span.bi-chevron-left")
            with_tag("span.ms-1.d-none", text: "Retour")
          end
        end
      end
    end

    it "renders right_content with a show button" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          with_tag("div.align-self-center.d-inline-flex") do
            with_tag("a.btn-primary", title: "Voir", href: "http://test.host/sites/1") do
              with_tag("span.bi-eye")
              with_tag("span.ms-1.d-none", text: "Voir")
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

    it "renders right_content with an extra_button and a show button" do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div.col-12.bg-body") do
        with_tag("div.d-flex") do
          with_tag("a.btn", text: "Button")
          with_tag("div.align-self-center.d-inline-flex") do
            with_tag("a.btn-primary", title: "Voir", href: "http://test.host/sites/1") do
              with_tag("span.bi-eye")
              with_tag("span.ms-1.d-none", text: "Voir")
            end
          end
        end
      end
    end
  end
end