module Spree
  module ActiveShipping
    module CanadaPostPWSOverride
      def self.included(base)
        base.class_eval do
          def self.default_location
            ActiveMerchant::Shipping::Location.new(
              country: 'CA',
              zip: 'K2B8J6'
            )
          end
        end
      end
    end
  end
end

