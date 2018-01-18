module Spree
  module Calculator::Shipping
    module CanadaPost
      class XpresspostInternational < Spree::Calculator::Shipping::CanadaPost::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t("canada_post.xpresspost_international")
        end
      end
    end
  end
end
