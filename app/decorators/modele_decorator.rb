# frozen_string_literal: true

class ModeleDecorator < ApplicationDecorator
  def network_types_to_s
    return Modele.human_attribute_name("network_types.blank") unless (n_t = network_types.presence)

    n_t.map { |type| Modele.human_attribute_name("network_types.#{type}") }.join(", ")
  end
end
