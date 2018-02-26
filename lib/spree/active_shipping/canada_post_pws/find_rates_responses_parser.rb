module Spree
  module ActiveShipping
    class CanadaPostPws::FindRatesResponsesParser
      def initialize(carrier:, responses:, origin:, destination:)
        @carrier = carrier
        @responses = responses
        @origin = origin
        @destination = destination
      end

      def self.call(carrier:, responses:, origin:, destination:)
        new(
          carrier: carrier,
          responses: responses,
          origin: origin,
          destination: destination
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

      attr_reader :carrier, :responses, :origin, :destination

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
        @parsed_responses ||= responses.map do |response|
          parse_response(response)
        end
      end

      def parse_response(response)
        carrier.parse_rates_response(response, origin, destination)
      end
    end
  end
end
