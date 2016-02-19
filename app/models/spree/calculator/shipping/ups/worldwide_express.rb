module Spree
  module Calculator::Shipping
    module Ups
      class WorldwideExpress < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :international
        end

        def self.service_code
          '07'
        end

        def self.description
          I18n.t("ups.worldwide_express")
        end
      end
    end
  end
end
