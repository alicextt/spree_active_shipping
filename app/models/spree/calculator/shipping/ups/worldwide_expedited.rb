module Spree
  module Calculator::Shipping
    module Ups
      class WorldwideExpedited < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :international
        end

        def self.service_code
          '08'
        end
      end
    end
  end
end
