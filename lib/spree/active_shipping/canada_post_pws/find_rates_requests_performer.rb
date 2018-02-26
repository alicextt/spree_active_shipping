module Spree
  module ActiveShipping
    class CanadaPostPws::FindRatesRequestsPerformer
      MAX_ASYNC_REQUESTS = 10

      def initialize(carrier:, url:, grouped_requests:, headers:)
        @carrier = carrier
        @url = url
        @grouped_requests = grouped_requests
        @headers = headers
        @mutex = Mutex.new
      end

      def self.call(carrier:, url:, grouped_requests:, headers:)
        new(
          carrier: carrier,
          url: url,
          grouped_requests: grouped_requests,
          headers: headers
        ).call
      end

      def call
        grouped_responses = {}

        requests_queue = grouped_requests.pop(MAX_ASYNC_REQUESTS)

        while requests_queue.any?
          threads = requests_queue.map do |queue_item|
            weight_and_dimensions = queue_item[0]
            request = queue_item[1]

            Thread.new do
              mutex.synchronize do
                grouped_responses[weight_and_dimensions] =
                  find_rate_from_cache(request)
              end
            end
          end

          # Wait for the queue to finish before continue
          threads.each(&:join)

          requests_queue = grouped_requests.pop(MAX_ASYNC_REQUESTS)
        end

        grouped_responses
      end

      private

      attr_reader :carrier, :url, :grouped_requests, :headers, :mutex

      def find_rate_from_cache(request)
        cache_key = find_rate_cache_key(request)

        Rails.cache.fetch(cache_key, expires_in: 1.hour) do
          carrier.ssl_post(url, request, headers)
        end
      end

      def find_rate_cache_key(request)
        request_hash = Digest::MD5.hexdigest(request)
        headers_hash = Digest::MD5.hexdigest(headers.to_a.join('|'))
        "#{carrier.name}-#{carrier.class}-#{url}-#{request_hash}-#{headers_hash}-#{I18n.locale}".gsub(' ', '')
      end
    end
  end
end
