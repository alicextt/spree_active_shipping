RSpec.describe Spree::ActiveShipping::CanadaPostPws::ShippingRates do
  subject do
    Spree::ActiveShipping::CanadaPostPws::ShippingRates.new(
      carrier: carrier,
      origin: origin,
      destination: destination,
      packages: packages,
      options: options,
      package: package,
      services: services
    )
  end

  let(:carrier) { double(:carrier) }
  let(:origin) { double(:origin) }
  let(:destination) { double(:destination) }
  let(:packages) { double(:packages) }
  let(:options) { double(:options) }
  let(:package) { double(:package) }
  let(:services) { double(:services) }

  let(:grouped_packages) { double(:grouped_packages) }
  let(:grouped_requests) { double(:grouped_requests) }
  let(:grouped_responses) { double(:grouped_responses) }
  let(:parsed_responses) { double(:parsed_responses) }

  describe '#call' do
    it 'should return shipping rates' do
      expect(Spree::ActiveShipping::CanadaPostPws::ShippingRates::GroupPackagesByWeightAndDimension).to(
        receive(:call).with(packages).and_return(grouped_packages)
      )

      expect(Spree::ActiveShipping::CanadaPostPws::ShippingRates::RequestsBuilder).to(
        receive(:call).
          with(
            carrier: carrier,
            origin: origin,
            destination: destination,
            grouped_packages: grouped_packages,
            options: options,
            package: package,
            services: services
          )
          .and_return(grouped_requests)
      )

      expect(Spree::ActiveShipping::CanadaPostPws::ShippingRates::Fetcher).to(
        receive(:call)
          .with(
            carrier: carrier,
            grouped_requests: grouped_requests,
            options: options
          )
          .and_return(grouped_responses)
      )

      expect(Spree::ActiveShipping::CanadaPostPws::ShippingRates::ResponsesParser).to(
        receive(:call)
          .with(
            carrier: carrier,
            origin: origin,
            destination: destination,
            grouped_responses: grouped_responses,
            grouped_packages: grouped_packages
          )
          .and_return(parsed_responses)
      )

      expect(subject.call).to eq(parsed_responses)
    end
  end
end
