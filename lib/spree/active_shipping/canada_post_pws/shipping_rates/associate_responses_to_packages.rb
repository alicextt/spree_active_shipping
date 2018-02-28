module Spree
  module ActiveShipping
    class CanadaPostPws::ShippingRates::AssociateResponsesToPackages
      def initialize(grouped_responses:, grouped_packages:)
        @grouped_responses = grouped_responses
        @grouped_packages = grouped_packages
      end

      def self.call(grouped_responses:, grouped_packages:)
        new(
          grouped_responses: grouped_responses,
          grouped_packages: grouped_packages
        ).call
      end

      def call
        ungrouped_responses = []

        grouped_responses.each do |weight_and_dimension, response|
          grouped_packages[weight_and_dimension].count.times do
            ungrouped_responses << response
          end
        end

        ungrouped_responses
      end

      private

      attr_reader :grouped_responses, :grouped_packages
    end
  end
end
