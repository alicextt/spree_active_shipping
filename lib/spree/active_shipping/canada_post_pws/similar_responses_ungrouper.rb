module Spree
  module ActiveShipping
    class CanadaPostPws::SimilarResponsesUngrouper
      def initialize(grouped_responses:, similar_packages:)
        @grouped_responses = grouped_responses
        @similar_packages = similar_packages
      end

      def self.call(grouped_responses:, similar_packages:)
        new(
          grouped_responses: grouped_responses,
          similar_packages: similar_packages
        ).call
      end

      def call
        ungrouped_responses = []

        grouped_responses.each do |weight_and_dimensions, response|
          similar_packages[weight_and_dimensions].count.times do
            ungrouped_responses << response
          end
        end

        ungrouped_responses
      end

      private

      attr_reader :grouped_responses, :similar_packages
    end
  end
end
