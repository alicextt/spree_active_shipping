module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class SmallPacketUsaAir < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post_pws.small_packet_usa_air')
        end
      end
    end
  end
end
