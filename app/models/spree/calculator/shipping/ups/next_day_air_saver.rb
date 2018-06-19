module Spree
  module Calculator::Shipping
    module Ups
      class NextDayAirSaver < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '13'
        end
      end
    end
  end
end
