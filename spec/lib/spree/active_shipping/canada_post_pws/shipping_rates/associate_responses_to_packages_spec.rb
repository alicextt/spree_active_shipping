RSpec.describe Spree::ActiveShipping::CanadaPostPws::ShippingRates::AssociateResponsesToPackages do
  subject do
    Spree::ActiveShipping::CanadaPostPws::ShippingRates::AssociateResponsesToPackages.new(
      grouped_responses: grouped_responses,
      grouped_packages: grouped_packages
    )
  end

  let(:grouped_responses) do
    {
      [10.0, [10.0, 10.0, 10.0]] => response_one,
      [20.0, [20.0, 20.0, 20.0]] => response_two
    }
  end

  let(:response_one) { double(:response_one) }
  let(:response_two) { double(:response_two) }

  let(:grouped_packages) do
    {
      [10.0, [10.0, 10.0, 10.0]] => [package_one, package_two, package_three],
      [20.0, [20.0, 20.0, 20.0]] => [package_four]
    }
  end

  let(:package_one) { double(:package_one) }
  let(:package_two) { double(:package_two) }
  let(:package_three) { double(:package_three) }
  let(:package_four) { double(:package_one) }

  describe '#call' do
    let(:expected_result) do
      [response_one, response_one, response_one, response_two]
    end

    it 'should return ungrouped responses' do
      expect(subject.call).to eq(expected_result)
    end
  end
end
