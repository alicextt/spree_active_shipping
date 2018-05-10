require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def self.carrier_name
          I18n.t('canada_post_pws.carrier_name')
        end

        def carrier
          canada_post_options = {
            endpoint: NemoSpreeCore.configuration.canada_post[:endpoint],
            customer_number: Spree::ActiveShipping::Config[:canada_post_customer_number],
            contract_id: Spree::ActiveShipping::Config[:canada_post_contract_id],
            api_key: Spree::ActiveShipping::Config[:canada_post_api_key],
            secret: Spree::ActiveShipping::Config[:canada_post_secret],
            platform_id: NemoSpreeCore.configuration.canada_post[:platform_id],
            language: I18n.locale
          }

          ActiveMerchant::Shipping::CanadaPostPWS.new(canada_post_options)
        end
      end
    end
  end
end
