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

          def headers(customer_credentials, accept = nil, content_type = nil)
            headers = {
              'Authorization'   => encoded_authorization(customer_credentials),
              'Accept-Language' => language
            }
            headers['Accept'] = accept if accept
            headers['Content-Type'] = content_type if content_type
            headers['Platform-Id'] = platform_id if platform_id

            headers
          end

          def valid_credentials?
            location = self.class.default_location
            find_rates(location, location, (ActiveMerchant::Shipping::Package.new(100,[10,10,10], units: :metric)))
          rescue ActiveShipping::ResponseError
            false
          else
            true
          end

          # Override the method to allow the use of multiple packages.
          # Each line item is a package (ActiveMerchant::Shipping::Package),
          # as Canada Post does not allow sending multiple packages when
          # fetching the services we need to make a request for each package.
          def find_rates(origin, destination, line_items = [], options = {}, package = nil, services = [])
            url = "#{endpoint}rs/ship/price"
            headers = headers(
              options,
              ActiveMerchant::Shipping::CanadaPostPWS::RATE_MIMETYPE,
              ActiveMerchant::Shipping::CanadaPostPWS::RATE_MIMETYPE
            )

            similar_packages = group_packages_by_weight_and_dimensions(line_items)
            grouped_requests = build_rates_requests(origin, destination, similar_packages, options, package, services)
            grouped_responses = peform_rates_requests_async(url, grouped_requests, headers)
            responses = ungroup_rates_responses(grouped_responses, similar_packages)
            parse_rates_responses(responses, origin, destination)
          rescue ActiveMerchant::ResponseError, ActiveMerchant::Shipping::ResponseError => e
            error_response(e.response.body, ActiveMerchant::Shipping::CPPWSRateResponse)
          end

          def contract_id_node(options)
            return unless options[:contract_id] || contract_id.present?

            XmlNode.new('contract-id', options[:contract_id] || contract_id)
          end

          def parcel_node(line_items, package = nil, options = {})
            weight = sanitize_weight_kg(package && !package.kilograms.zero? ? package.kilograms.to_f : line_items.sum(&:kilograms).to_f)

            XmlNode.new('parcel-characteristics') do |el|
              el << XmlNode.new('weight', '%#2.3f' % weight)

              pkg_dim = package.try(:cm) || line_items.first.cm
              if pkg_dim && !pkg_dim.select { |x| x != 0 }.empty?
                el << XmlNode.new('dimensions') do |dim|
                  dim << XmlNode.new('length', '%.1f' % ((pkg_dim[2] * 10).round / 10.0)) if pkg_dim.size >= 3
                  dim << XmlNode.new('width', '%.1f' % ((pkg_dim[1] * 10).round / 10.0)) if pkg_dim.size >= 2
                  dim << XmlNode.new('height', '%.1f' % ((pkg_dim[0] * 10).round / 10.0)) if pkg_dim.size >= 1
                end
              end

              el << XmlNode.new('mailing-tube', line_items.any?(&:tube?))
              el << XmlNode.new('oversized', true) if line_items.any?(&:oversized?)
              el << XmlNode.new('unpackaged', line_items.any?(&:unpackaged?))
            end
          end

          private

          def group_packages_by_weight_and_dimensions(packages)
            Spree::ActiveShipping::CanadaPostPws::SimilarPackagesGrouper.call(
              packages
            )
          end

          def build_rates_requests(origin, destination, grouped_packages, options, package, services)
            Spree::ActiveShipping::CanadaPostPws::FindRatesRequestsBuilder.call(
              carrier: self,
              grouped_packages: grouped_packages,
              origin: origin,
              destination: destination,
              options: options,
              package: package,
              services: services
            )
          end

          def peform_rates_requests_async(url, grouped_requests, headers)
            Spree::ActiveShipping::CanadaPostPws::FindRatesRequestsPerformer.call(
              carrier: self,
              url: url,
              grouped_requests: grouped_requests,
              headers: headers
            )
          end

          def ungroup_rates_responses(grouped_responses, similar_packages)
            Spree::ActiveShipping::CanadaPostPws::SimilarResponsesUngrouper.call(
              grouped_responses: grouped_responses,
              similar_packages: similar_packages
            )
          end

          def parse_rates_responses(responses, origin, destination)
            Spree::ActiveShipping::CanadaPostPws::FindRatesResponsesParser.call(
              carrier: self,
              responses: responses,
              origin: origin,
              destination: destination
            )
          end
        end
      end
    end
  end
end

