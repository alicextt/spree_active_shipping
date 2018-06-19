module Spree
  module Calculator::Shipping
    module Ups
      class NextDayAirEarlyAm < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '14'
        end
      end
    end
  end
end
