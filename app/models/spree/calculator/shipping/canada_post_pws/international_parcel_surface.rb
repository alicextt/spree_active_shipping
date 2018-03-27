module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class InternationalParcelSurface < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post_pws.international_parcel_surface')
        end
      end
    end
  end
end
