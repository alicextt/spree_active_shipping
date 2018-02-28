RSpec.describe Spree::ActiveShipping::CanadaPostPws::ShippingRates::RequestsBuilder do
  subject do
    Spree::ActiveShipping::CanadaPostPws::ShippingRates::RequestsBuilder.new(
      carrier: carrier,
      origin: origin,
      destination: destination,
      grouped_packages: grouped_packages,
      options: options,
      package: package,
      services: services
    )
  end

  let(:carrier) { double(:carrier) }
  let(:origin) { double(:origin) }
  let(:destination) { double(:destination) }
  let(:options) { double(:options) }
  let(:package) { double(:package) }
  let(:services) { double(:services) }

  let(:grouped_packages) do
    {
      weight_and_dimensions_one => [package_one],
      weight_and_dimensions_two => [package_two]
    }
  end

  let(:weight_and_dimensions_one) { [10.0, [10.0, 10.0, 10.0]] }
  let(:weight_and_dimensions_two) { [20.0, [20.0, 20.0, 20.0]] }

  let(:package_one) { double(:package_one) }
  let(:package_two) { double(:package_two) }

  let(:request_one) { double(:request_one) }
  let(:request_two) { double(:request_two) }

  describe '#call' do
    let(:expected_result) do
      [
        [weight_and_dimensions_one, request_one],
        [weight_and_dimensions_two, request_two]
      ]
    end

    it 'should return grouped requests' do
      expect(carrier).to(
        receive(:build_rates_request)
          .with(
            origin,
            destination,
            package_one,
            options,
            package,
            services
          )
          .and_return(request_one)
      )

      expect(carrier).to(
        receive(:build_rates_request)
          .with(
            origin,
            destination,
            package_two,
            options,
            package,
            services
          )
          .and_return(request_two)
      )

      expect(subject.call).to eq(expected_result)
    end
  end
end
