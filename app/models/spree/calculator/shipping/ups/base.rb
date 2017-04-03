require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Ups
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def carrier
          ActiveMerchant::Shipping::UPS.new(carrier_details)
        end

        protected
        # weight limit in ounces http://www.ups.com/content/us/en/resources/prepare/oversize.html
        def max_weight_for_country(country)
          2400    # 150 lbs
        end

        private

        def carrier_details
          @carrier_details ||= begin
            details = {
              login: Spree::ActiveShipping::Config[:ups_login],
              password: Spree::ActiveShipping::Config[:ups_password],
              key: Spree::ActiveShipping::Config[:ups_key],
              test: Spree::ActiveShipping::Config[:test_mode]
            }

            if Spree::ActiveShipping::Config[:ups_rate_type] == 'negotiated' && shipper_number = Spree::ActiveShipping::Config[:shipper_number]
              details.merge!(origin_account: shipper_number)
            end

            if ups_pickup_type = Spree::ActiveShipping::Config[:ups_pickup_type]
              details.merge!(pickup_type: ups_pickup_type)
            end

            details
          end
        end

        # unique key for caching
        def carrier_key
          "#{carrier.name}-#{Digest::MD5.hexdigest(carrier_details.to_s)}"
        end
      end
    end
  end
end
