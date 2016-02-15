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

        def self.description
          I18n.t("ups.second_day_air_am")
        end
      end
    end
  end
end
