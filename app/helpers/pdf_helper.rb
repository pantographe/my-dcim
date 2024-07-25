# frozen_string_literal: true

module PdfHelper
  def replace_css_variables(css_content)
    css_variables = find_css_variables(css_content)

    css_variables.each do |variable|
      css_content = css_content.gsub("var(#{variable[:name]})", variable[:value])
    end

    css_content
  end

  private

  def find_css_variables(css_content)
    tree = Crass.parse(css_content, preserve_comments: false)
    root_node = tree.find { |e| e[:node] == :style_rule && e[:selector][:value] = :root }

    properties = root_node[:children].filter { |e| e[:node] == :property }
    properties.filter { |e| e[:name].start_with?("--") }.map { |e| { name: e[:name], value: e[:value] } }
  end
end
