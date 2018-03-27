module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class TrackedPacketUsa < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post_pws.tracked_packet_usa')
        end
      end
    end
  end
end
