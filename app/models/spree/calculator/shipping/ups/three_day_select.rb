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

        def self.description
          I18n.t("ups.three_day_select")
        end
      end
    end
  end
end
