module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class SmallPacketsSurface < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :domestic
        end

        def self.description
          I18n.t('canada_post.small_packets_surface')
        end
      end
    end
  end
end
