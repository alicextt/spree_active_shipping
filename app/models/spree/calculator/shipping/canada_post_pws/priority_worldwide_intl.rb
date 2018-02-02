module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class PriorityWorldwideIntl < Spree::Calculator::Shipping::CanadaPostPws::Base
        def self.geo_group
          :international
        end

        def self.description
          I18n.t('canada_post.priority_worldwide_intl')
        end
      end
    end
  end
end

