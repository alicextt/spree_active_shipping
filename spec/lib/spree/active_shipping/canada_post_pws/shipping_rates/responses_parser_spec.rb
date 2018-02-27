RSpec.describe Spree::ActiveShipping::CanadaPostPws::ShippingRates::ResponsesParser do
  subject do
    Spree::ActiveShipping::CanadaPostPws::ShippingRates::ResponsesParser.new(
      carrier: carrier,
      origin: origin,
      destination: destination,
      grouped_responses: grouped_responses,
      grouped_packages: grouped_packages
    )
  end

  let(:carrier) { double(:carrier) }
  let(:origin) { double(:origin) }
  let(:destination) { double(:destination) }
  let(:grouped_responses) { double(:grouped_responses) }
  let(:grouped_packages) { double(:grouped_packages) }

  let(:responses) { [response_one, response_two, response_three] }

  let(:response_one) { double(:response_one) }
  let(:parsed_response_one) { double(:parsed_response_one, rates: rates_one) }
  let(:rates_one) { [rate_one, rate_two, rate_three, rate_four, rate_five] }

  let(:response_two) { double(:response_two) }
  let(:parsed_response_two) { double(:parsed_response_two, rates: rates_two) }
  let(:rates_two) { [rate_one, rate_two, rate_three, rate_four] }

  let(:response_three) { double(:response_three) }
  let(:parsed_response_three) { double(:parsed_response_three, rates: rates_three) }
  let(:rates_three) { [rate_one, rate_two, rate_three] }

  let(:rate_one) do
    double(
      :rate_one,
      service_code: 1,
      service_name: 'Service One',
      total_price: 10.0,
      currency: 'CAD',
      delivery_range: nil
    )
  end

  let(:rate_two) do
    double(
      :rate_two,
      service_code: 2,
      service_name: 'Service Two',
      total_price: 20.0,
      currency: 'CAD',
      delivery_range: nil
    )
  end

  let(:rate_three) do
    double(
      :rate_three,
      service_code: 3,
      service_name: 'Service Three',
      total_price: 30.0,
      currency: 'CAD',
      delivery_range: nil
    )
  end

  let(:rate_four) { double(:rate_four, service_name: 'Service Four') }
  let(:rate_five) { double(:rate_five, service_name: 'Service Five') }

  let(:rate_estimate_one) { double(:rate_estimate_one) }
  let(:rate_estimate_two) { double(:rate_estimate_two) }
  let(:rate_estimate_three) { double(:rate_estimate_three) }

  let(:parsed_rates) do
    [rate_estimate_one, rate_estimate_two, rate_estimate_three]
  end

  let(:rate_response) { double(:rate_response) }

  describe '#call' do
    let(:expected_result) do

    end

    it 'should return parsed responses' do
      expect(Spree::ActiveShipping::CanadaPostPws::ShippingRates::AssociateResponsesToPackages).to(
        receive(:call)
          .with(
            grouped_responses: grouped_responses,
            grouped_packages: grouped_packages
          )
          .and_return(responses)
      )

      expect(carrier).to(
        receive(:parse_rates_response)
          .with(response_one, origin, destination)
          .and_return(parsed_response_one)
      )

      expect(carrier).to(
        receive(:parse_rates_response)
          .with(response_two, origin, destination)
          .and_return(parsed_response_two)
      )

      expect(carrier).to(
        receive(:parse_rates_response)
          .with(response_three, origin, destination)
          .and_return(parsed_response_three)
      )

      expect(ActiveMerchant::Shipping::RateEstimate).to(
        receive(:new)
          .with(
            origin,
            destination,
            carrier,
            rate_one.service_name,
            service_code: rate_one.service_code,
            total_price: 30.0,
            currency: rate_one.currency,
            delivery_range: rate_one.delivery_range
          )
          .and_return(rate_estimate_one)
      )

      expect(ActiveMerchant::Shipping::RateEstimate).to(
        receive(:new)
          .with(
            origin,
            destination,
            carrier,
            rate_two.service_name,
            service_code: rate_two.service_code,
            total_price: 60.0,
            currency: rate_two.currency,
            delivery_range: rate_two.delivery_range
          )
          .and_return(rate_estimate_two)
      )

      expect(ActiveMerchant::Shipping::RateEstimate).to(
        receive(:new)
          .with(
            origin,
            destination,
            carrier,
            rate_three.service_name,
            service_code: rate_three.service_code,
            total_price: 90.0,
            currency: rate_three.currency,
            delivery_range: rate_three.delivery_range
          )
          .and_return(rate_estimate_three)
      )

      expect(ActiveMerchant::Shipping::CPPWSRateResponse).to(
        receive(:new)
          .with(true, '', {}, rates: parsed_rates)
          .and_return(rate_response)
      )

      expect(subject.call).to eq(rate_response)
    end
  end
end
