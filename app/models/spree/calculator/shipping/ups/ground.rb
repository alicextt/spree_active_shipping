module Spree
  module Calculator::Shipping
    module Ups
      class Ground < Spree::Calculator::Shipping::Ups::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          '03'
        end

        def self.description
          I18n.t("ups.ground")
        end
      end
    end
  end
end
