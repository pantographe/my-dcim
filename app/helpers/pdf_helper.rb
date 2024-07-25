# frozen_string_literal: true

module PdfHelper
  def replace_css_variables(css_content)
    css_variables = find_css_variables(css_content)

    css_variables.each do |var|
      # Regex: var(--var-name[^)]*)
      css_content = css_content.gsub(/var\(#{var[:name]}[^)]*\)/, var[:values].first)
    end

    css_content.html_safe
  end

  private

  # rubocop:disable Rails/Pluck
  def find_css_variables(css_content)
    tree = Crass.parse(css_content, preserve_comments: false)

    selectors = tree.find_all { |e| e[:node] == :style_rule }

    properties = selectors.map { |e| e[:children] }.flatten.filter { |e| e[:node] == :property }
    variables_declarations = properties.filter { |e| e[:name].start_with?("--") }.group_by { |e| e[:name] }

    variables = []

    variables_declarations.each do |k, v| # rubocop:disable Style/MapIntoArray
      variables << {
        name: k,
        values: v.map { |e| e[:value] },
        count: v.count
      }
    end

    variables
  end
  # rubocop:enable Rails/Pluck
end
