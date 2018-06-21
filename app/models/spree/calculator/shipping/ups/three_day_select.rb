module Spree
  module Calculator::Shipping
    module Ups
      class ThreeDaySelect < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '12'
        end
      end
    end
  end
end
