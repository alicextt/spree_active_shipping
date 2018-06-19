module Spree
  module Calculator::Shipping
    module Ups
      class SecondDayAirAm < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '59'
        end
      end
    end
  end
end
