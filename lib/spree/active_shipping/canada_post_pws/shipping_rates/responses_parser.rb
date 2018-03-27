module Spree
  module ActiveShipping
    class CanadaPostPws::ShippingRates::ResponsesParser
      def initialize(carrier:, origin:, destination:, grouped_responses:, grouped_packages:)
        @carrier = carrier
        @origin = origin
        @destination = destination
        @grouped_responses = grouped_responses
        @grouped_packages = grouped_packages
      end

      def self.call(carrier:, origin:, destination:, grouped_responses:, grouped_packages:)
        new(
          carrier: carrier,
          origin: origin,
          destination: destination,
          grouped_responses: grouped_responses,
          grouped_packages: grouped_packages
        ).call
      end

      def call
        ActiveMerchant::Shipping::CPPWSRateResponse.new(
          true,
          '',
          {},
          rates: parsed_rates
        )
      end

      private

      attr_reader(
        :carrier,
        :origin,
        :destination,
        :grouped_responses,
        :grouped_packages
      )

      def parsed_rates
        parsed_rates = rates_available_to_all_packages.map do |_, value|
          rate = value.first

          ActiveMerchant::Shipping::RateEstimate.new(
            origin,
            destination,
            carrier,
            rate.service_name,
            service_code: rate.service_code,
            total_price: value.sum(&:total_price),
            currency: rate.currency,
            delivery_range: rate.delivery_range
          )
        end
      end

      def rates_available_to_all_packages
        parsed_responses
          .map(&:rates)
          .flatten
          .group_by(&:service_name)
          .select { |_, value| value.count == parsed_responses.count }
      end

      def parsed_responses
        @parsed_responses ||= ungrouped_responses.map do |response|
          parse_response(response)
        end
      end

      def parse_response(response)
        carrier.parse_rates_response(response, origin, destination)
      end

      def ungrouped_responses
        Spree::ActiveShipping::CanadaPostPws::ShippingRates::AssociateResponsesToPackages.call(
          grouped_responses: grouped_responses,
          grouped_packages: grouped_packages
        )
      end
    end
  end
end
