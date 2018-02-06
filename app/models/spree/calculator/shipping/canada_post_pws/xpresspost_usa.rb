module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class XpresspostUsa < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post_pws.xpresspost_usa')
        end
      end
    end
  end
end
