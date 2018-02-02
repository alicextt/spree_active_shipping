module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class Expedited < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :domestic
        end

        def self.description
          I18n.t('canada_post.expedited')
        end
      end
    end
  end
end
