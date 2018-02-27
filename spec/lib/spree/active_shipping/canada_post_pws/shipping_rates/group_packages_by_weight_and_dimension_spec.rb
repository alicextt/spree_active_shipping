RSpec.describe Spree::ActiveShipping::CanadaPostPws::ShippingRates::GroupPackagesByWeightAndDimension do
  subject do
    Spree::ActiveShipping::CanadaPostPws::ShippingRates::GroupPackagesByWeightAndDimension.new(
      packages
    )
  end

  let(:packages) { [package_one, package_two, package_three, package_four] }

  let(:package_one) do
    double(:package_one, kilograms: 10.0, cm: [10.0, 10.0, 10.0])
  end

  let(:package_two) do
    double(:package_one, kilograms: 10.0, cm: [10.0, 10.0, 10.0])
  end

  let(:package_three) do
    double(:package_one, kilograms: 10.0, cm: [15.0, 15.0, 15.0])
  end

  let(:package_four) do
    double(:package_one, kilograms: 20.0, cm: [20.0, 20.0, 20.0])
  end

  describe '#call' do
    let(:expected_result) do
      {
        [10.0, [10.0, 10.0, 10.0]] => [package_one, package_two],
        [10.0, [15.0, 15.0, 15.0]] => [package_three],
        [20.0, [20.0, 20.0, 20.0]] => [package_four]
      }
    end

    it 'should return packages grouped by weight and dimension' do
      expect(subject.call).to eq(expected_result)
    end
  end
end
