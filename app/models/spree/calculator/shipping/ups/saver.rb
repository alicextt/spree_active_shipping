module Spree
  module Calculator::Shipping
    module Ups
      class Saver < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :international
        end

        def self.service_code
          '65'
        end
      end
    end
  end
end
