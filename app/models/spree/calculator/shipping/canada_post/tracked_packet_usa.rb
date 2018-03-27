module Spree
  module Calculator::Shipping
    module CanadaPost
      class TrackedPacketUsa < Spree::Calculator::Shipping::CanadaPost::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t("canada_post.tracked_packet_usa")
        end
      end
    end
  end
end
