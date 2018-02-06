module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class TrackedPacketInternational < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post_pws.tracked_packet_international')
        end
      end
    end
  end
end
