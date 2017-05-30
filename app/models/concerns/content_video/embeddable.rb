class ContentVideo < ActiveRecord::Base
  module Embeddable
    SUPPORTED_PARTIES = %w(
      youtube
    ).freeze

    def supported_party?
      supported_party.present?
    end

    def embedded_url
      send("embedded_#{supported_party}") || url_without_schema
    end

    def thumbnail
      send("thumbnail_#{supported_party}") if supported_party?
    end

    def url_without_schema
      @url_without_schema ||= if uri.present?
          url.sub("#{uri.scheme}:", "")
        else
          url
        end
    end

    private

    def supported_party
      @supported_party ||= SUPPORTED_PARTIES.detect do |party|
        url.include?(party)
      end
    end

    def embedded_youtube
      if uri_params.present? && uri_params["v"]
        "//www.youtube.com/embed/#{uri_params["v"].first}"
      end
    end

    def thumbnail_youtube
      if uri_params.present? && uri_params["v"]
        "//img.youtube.com/vi/#{uri_params["v"].first}/0.jpg"
      end
    end

    def uri_params
      @uri_params ||= CGI::parse(
        uri.query
      ) if uri.try(:query).present?
    end

    def uri
      @uri ||= URI(url)
    rescue URI::InvalidURIError
    end
  end
end
