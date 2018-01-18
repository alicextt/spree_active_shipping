module Spree
  module Calculator::Shipping
    module CanadaPost
      class Regular < Spree::Calculator::Shipping::CanadaPost::Base
        def self.geo_group
          :domestic
        end

        def self.description
          I18n.t("canada_post.regular")
        end
      end
    end
  end
end
