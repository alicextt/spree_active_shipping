module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class ExpeditedUsa < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post.expedited_usa')
        end
      end
    end
  end
end
