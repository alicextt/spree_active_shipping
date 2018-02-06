module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class Xpresspost < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :domestic
        end

        def self.description
          I18n.t('canada_post_pws.xpresspost')
        end
      end
    end
  end
end
