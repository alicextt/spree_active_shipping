RSpec.describe Spree::ActiveShipping::CanadaPostPws::FindRatesRequestsPerformer do
  subject do
    Spree::ActiveShipping::CanadaPostPws::FindRatesRequestsPerformer.new(
      carrier: carrier,
      url: url,
      grouped_requests: grouped_requests,
      headers: headers
    )
  end

  let(:carrier) { double(:carrier, class: 'CanadaPostPws', name: 'Canada Post') }
  let(:url) { 'some-url' }
  let(:headers) { { field: 'value' } }

  let(:grouped_requests) do
    [
      [[10.0, [10.0, 10.0, 10.0]], request_one],
      [[20.0, [20.0, 20.0, 20.0]], request_two],
      [[30.0, [30.0, 30.0, 30.0]], request_three]
    ]
  end

  let(:request_one) { 'request_one' }
  let(:request_two) { 'request_two' }
  let(:request_three) { 'request_three' }

  let(:response_one) { 'response_one' }
  let(:response_two) { 'response_two' }
  let(:response_three) { 'response_three' }

  before do
    Rails.cache.clear
  end

  describe '#call' do
    it 'should return grouped responses' do
      expect(carrier).to(
        receive(:ssl_post)
          .with(url, request_one, headers)
          .and_return(response_one)
      )

      expect(carrier).to(
        receive(:ssl_post)
          .with(url, request_two, headers)
          .and_return(response_two)
      )

      expect(carrier).to(
        receive(:ssl_post)
          .with(url, request_three, headers)
          .and_return(response_three)
      )

      result = subject.call

      expect(result[[10.0, [10.0, 10.0, 10.0]]]).to eq(response_one)
      expect(result[[20.0, [20.0, 20.0, 20.0]]]).to eq(response_two)
      expect(result[[30.0, [30.0, 30.0, 30.0]]]).to eq(response_three)
    end
  end
end
