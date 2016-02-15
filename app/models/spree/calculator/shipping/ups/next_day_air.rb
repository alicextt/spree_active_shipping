module Spree
  module Calculator::Shipping
    module Ups
      class NextDayAir < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '01'
        end

        def self.description
          I18n.t("ups.next_day_air")
        end
      end
    end
  end
end
