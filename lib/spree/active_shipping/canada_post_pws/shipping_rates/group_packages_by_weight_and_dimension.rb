module Spree
  module ActiveShipping
    class CanadaPostPws::ShippingRates::GroupPackagesByWeightAndDimension
      def initialize(packages)
        @packages = Array(packages)
      end

      def self.call(packages)
        new(packages).call
      end

      def call
        packages.group_by { |package| [package.kilograms, package.cm] }
      end

      private

      attr_reader :packages
    end
  end
end
