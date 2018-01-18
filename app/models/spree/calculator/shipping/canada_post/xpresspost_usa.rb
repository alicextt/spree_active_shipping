module Spree
  module Calculator::Shipping
    module CanadaPost
      class XpresspostUsa < Spree::Calculator::Shipping::CanadaPost::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t("canada_post.xpresspost_usa")
        end
      end
    end
  end
end
