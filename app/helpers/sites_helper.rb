# frozen_string_literal: true

module SitesHelper
  def delivery_map_accepted_mime_types
    Site.validators_on(:delivery_map).find { |v| v.is_a?(ActiveStorageValidations::ContentTypeValidator) }
      .options[:in].map { |f| Mime[f].to_s }
      .uniq
      .join(", ")
  end
end
