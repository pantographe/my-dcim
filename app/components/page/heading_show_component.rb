# frozen_string_literal: true

module Page
  class HeadingShowComponent < ApplicationComponent
    renders_one :extra_buttons

    def initialize(resource:, title:, breadcrumb:)
      @resource = resource
      @title = title
      @breadcrumb = breadcrumb

      super
    end

    def call
      render HeadingComponent.new(
        title: @title, breadcrumb: @breadcrumb, back_button_url: polymorphic_path(@resource.class)
      ) do |heading|
        heading.with_right_content do
          tag.div class: "align-self-center d-inline-flex" do
            concat(extra_buttons) if extra_buttons?

            concat(render(ButtonComponent.new(t("action.edit"),
                                              url: [:edit, @resource],
                                              variant: :info,
                                              icon: "pencil",
                                              is_responsive: true)))
          end
        end
      end
    end
  end
end
