module Spree
  module Calculator::Shipping
    module CanadaPost
      class SmallPacketsSurface < Spree::Calculator::Shipping::CanadaPost::Base
        def self.geo_group
          :domestic
        end

        def self.description
          I18n.t("canada_post.small_packets_surface")
        end
      end
    end
  end
end
