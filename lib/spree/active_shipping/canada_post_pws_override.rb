module Spree
  module ActiveShipping
    module CanadaPostPWSOverride
      def self.included(base)
        def initialize(options = {})
          @contract_id = options[:contract_id]

          super(options)
        end

        base.class_eval do
          cattr_reader :name

          attr_accessor :contract_id

          def self.default_location
            ActiveMerchant::Shipping::Location.new(
              country: 'CA',
              zip: 'K2B8J6'
            )
          end

          def contract_id_node(options)
            return unless options[:contract_id] || contract_id.present?

            XmlNode.new('contract-id', options[:contract_id] || contract_id)
          end
        end
      end
    end
  end
end

