module Spree
  module ActiveShipping
    class CanadaPostPws::ShippingRates::RequestsBuilder
      def initialize(carrier:, origin:, destination:, grouped_packages:, options:, package:, services:)
        @carrier = carrier
        @origin = origin
        @destination = destination
        @grouped_packages = grouped_packages
        @options = options
        @package = package
        @services = services
      end

      def self.call(carrier:, origin:, destination:, grouped_packages:, options:, package:, services:)
        new(
          carrier: carrier,
          origin: origin,
          destination: destination,
          grouped_packages: grouped_packages,
          options: options,
          package: package,
          services: services
        ).call
      end

      def call
        grouped_packages.map do |weight_and_dimensions, packages|
          request = build_request(packages)
          [weight_and_dimensions, request]
        end
      end

      private

      attr_reader(
        :carrier,
        :grouped_packages,
        :origin,
        :destination,
        :options,
        :package,
        :services
      )

      def build_request(packages)
        carrier.build_rates_request(
          origin,
          destination,
          packages.first,
          options,
          package,
          services
        )
      end
    end
  end
end
