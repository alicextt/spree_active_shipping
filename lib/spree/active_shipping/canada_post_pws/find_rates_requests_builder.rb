module Spree
  module ActiveShipping
    class CanadaPostPws::FindRatesRequestsBuilder
      def initialize(carrier:, grouped_packages:, origin:, destination:, options:, package:, services:)
        @carrier = carrier
        @grouped_packages = grouped_packages
        @origin = origin
        @destination = destination
        @options = options
        @package = package
        @services = services
      end

      def self.call(carrier:, grouped_packages:, origin:, destination:, options:, package:, services:)
        new(
          carrier: carrier,
          grouped_packages: grouped_packages,
          origin: origin,
          destination: destination,
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
