module Spree
  module ActiveShipping
    class CanadaPostPws::ShippingRates
      def initialize(carrier:, origin:, destination:, packages:, options:, package:, services:)
        @carrier = carrier
        @origin = origin
        @destination = destination
        @packages = packages
        @options = options
        @package = package
        @services = services
      end

      def self.call(carrier:, origin:, destination:, packages:, options:, package:, services:)
        new(
          carrier: carrier,
          origin: origin,
          destination: destination,
          packages: packages,
          options: options,
          package: package,
          services: services
        ).call
      end

      def call
        parsed_responses
      end

      private

      attr_reader(
       :carrier,
       :origin,
       :destination,
       :packages,
       :options,
       :package,
       :services
      )

      def parsed_responses
        Spree::ActiveShipping::CanadaPostPws::ShippingRates::ResponsesParser.call(
          carrier: carrier,
          origin: origin,
          destination: destination,
          grouped_responses: grouped_responses,
          grouped_packages: grouped_packages
        )
      end

      def grouped_responses
        Spree::ActiveShipping::CanadaPostPws::ShippingRates::Fetcher.call(
          carrier: carrier,
          grouped_requests: grouped_requests,
          options: options
        )
      end

      def grouped_requests
        Spree::ActiveShipping::CanadaPostPws::ShippingRates::RequestsBuilder.call(
          carrier: carrier,
          origin: origin,
          destination: destination,
          grouped_packages: grouped_packages,
          options: options,
          package: package,
          services: services
        )
      end

      def grouped_packages
        @grouped_packages ||=
          Spree::ActiveShipping::CanadaPostPws::ShippingRates::GroupPackagesByWeightAndDimension.call(
            packages
          )
      end
    end
  end
end
