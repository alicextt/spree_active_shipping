module Spree
  module Calculator::Shipping
    module Ups
      class SecondDayAir < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '02'
        end
      end
    end
  end
end
