# frozen_string_literal: true

require "rails_helper"

RSpec.describe List::DataTableComponent, type: :component do
  let(:record_class) do
    Data.define(:id, :product, :price, :sku, :qty, :sales)
  end

  let(:component) { described_class.new(data) }
  let(:rendered_component) { render_inline(component, &block).to_html }

  let(:data) do
    [
      record_class.new(1, "Emerald Silk Gown", "$875.00", 124_689, 140, "$122,500.00"),
      record_class.new(2, "Mauve Cashmere Scarf", "$230.00", 124_533, 83, "$19,090.00"),
      record_class.new(3, "Navy Merino Wool Blazer with khaki chinos and yellow belt", "$445.00", 124_518, 32, "$14,240.00"),
    ]
  end

  let(:block) do
    proc do |table|
      table.with_column("name", &:product)
    end
  end

  it do # rubocop:disable RSpec/ExampleLength
    expect(rendered_component).to have_tag("div.table-responsive") do
      with_tag("table.table") do
        with_tag("thead") do
          with_tag("tr") do
            with_tag("th", text: "name")
          end
        end
        with_tag("tbody") do
          data.each do |row|
            with_tag("tr") do
              with_tag("td", text: row.product)
            end
          end
        end
      end
    end
  end

  context "with bulk_actions" do
    let(:block) do
      proc do |table|
        table.with_bulk_action(url: "/bulk/servers", method: :delete, class: "btn btn-danger",
                               data: { confirm: "are you sure?" })
        table.with_column("name", &:product)
      end
    end

    it do # rubocop:disable RSpec/ExampleLength
      expect(rendered_component).to have_tag("div", with: { "data-controller": "bulk-actions" }) do
        with_tag("div", with: { style: "display: none;", "data-bulk-actions-target": "actionsContainer" }) do
          with_tag("div.card") do
            with_tag("div.card-body") do
              with_tag("div.d-flex") do
                with_tag("span") do
                  with_tag("span.fw-bolder", with: { "data-bulk-actions-target": "checkedCount" })
                end
                with_tag("button.btn-danger.btn", with: {
                  "data-bulk-actions-method-param": "delete", "data-bulk-actions-url-param": "/bulk/servers",
                  "data-bulk-actions-confirm-param": "are you sure?",
                  "data-action": "bulk-actions#submit",
                  type: "button"
                })
              end
            end
          end
        end
        with_tag("thead") do
          with_tag("tr > th", with: { style: "width: 0;" }) do
            with_tag("input", with: { type: "checkbox", "data-bulk-actions-target": "checkboxAll" })
          end
        end
        with_tag("tbody") do
          data.each do |row|
            with_tag("tr > td") do
              with_tag("input", with: {
                type: "checkbox", name: "ids[]", value: row.id,
                "data-bulk-actions-target": "checkbox"
              })
            end
          end
        end
      end
    end
  end
end
