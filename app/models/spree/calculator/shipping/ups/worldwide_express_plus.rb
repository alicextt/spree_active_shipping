module Spree
  module Calculator::Shipping
    module Ups
      class WorldwideExpressPlus < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :international
        end

        def self.service_code
          '54'
        end

        def self.description
          I18n.t("ups.worldwide_express_plus")
        end
      end
    end
  end
end
