module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class PriorityWorldwideParcelIntl < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post_pws.priority_worldwide_parcel_intl')
        end
      end
    end
  end
end

