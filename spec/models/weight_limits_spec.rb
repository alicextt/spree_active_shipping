require 'spec_helper'
include ActiveMerchant::Shipping

module ActiveShipping
  describe Spree::ShippingCalculator do

    let(:country) { mock_model Spree::Country, iso: "CA", state_name: "Quebec", state: nil }
    let(:address) { mock_model Spree::Address, country: country, state_name: country.state_name, city: "Montreal", zipcode: "H2B", state: nil }
    let(:usa) { FactoryGirl.create(:country, name: "USA", iso: "US") }
    let(:state) { FactoryGirl.create(:state, country: usa, abbr: 'MD', name: 'Maryland')}
    let(:us_address) { FactoryGirl.create(:address, country: usa, state: state, city: "Chevy Chase", zipcode: "20815") }
    let(:package1) { mock_model(Spree::ProductPackage, length: 12, width: 24, height: 47, weight: 36) }
    let(:package2) { mock_model(Spree::ProductPackage, length: 6, width: 6, height: 51, weight: 43) }
    let(:variant1) { build(:variant, weight: 20.0) }
    let(:variant2) { build(:variant, weight: 5.25) }
    let(:variant3) { build(:variant, weight: 29.0) }
    let(:variant4) { build(:variant, weight: 100.0) }
    let(:variant5) { build(:variant, weight: 0) }
    let(:variant6) { build(:variant, weight: -1.0) }
    let(:variant7) { double(Spree::Variant, weight: 29.0, product: mock_model(Spree::Product, product_packages: [package1, package2])) }
    let(:variant8) { double(Spree::Variant, weight: 5.25, product: mock_model(Spree::Product, product_packages: [])) }
    let(:california) { FactoryGirl.create(:state, country: usa, abbr: 'CA', name: 'California') }
    let(:stock_location) { FactoryGirl.create(:stock_location, address1: '1313 S Harbor Blvd', address2: '', city: 'Anaheim', state: california, country: usa, phone: '7147814000', active: 1) }
    let(:line_item1) { double(Spree::LineItem, variant: variant1) }
    let(:line_item2) { double(Spree::LineItem, variant: variant2) }
    let(:line_item3) { double(Spree::LineItem, variant: variant3) }
    let(:line_item4) { double(Spree::LineItem, variant: variant4) }
    let(:line_item5) { double(Spree::LineItem, variant: variant5) }
    let(:line_item6) { double(Spree::LineItem, variant: variant6) }
    let(:line_item7) { double(Spree::LineItem, variant: variant7) }
    let(:line_item8) { double(Spree::LineItem, variant: variant8) }
    let(:package) do
      double(
        Spree::Stock::Package,
        order: mock_model(Spree::Order, ship_address: address),
        contents: [
          Spree::Stock::Package::ContentItem.new(line_item1, variant1, 10),
          Spree::Stock::Package::ContentItem.new(line_item2, variant2, 4),
          Spree::Stock::Package::ContentItem.new(line_item3, variant3, 1)
        ],
        stock_location: stock_location
      )
    end

    let(:too_heavy_package) do
      Spree::Stock::Package.extend ActiveModel::Naming
      mock_model(
        Spree::Stock::Package,
        order: mock_model(Spree::Order, ship_address: address),
        stock_location: stock_location,
        contents: [
          Spree::Stock::Package::ContentItem.new(line_item3, variant3, 2),
          Spree::Stock::Package::ContentItem.new(line_item4, variant4, 2)
        ]
      )
    end

    let(:us_package) do
      double(Spree::Stock::Package,
          stock_location: stock_location,
          order: mock_model(Spree::Order, ship_address: us_address),
          contents: [Spree::Stock::Package::ContentItem.new(line_item1, variant1, 10),
                    Spree::Stock::Package::ContentItem.new(line_item2, variant2, 4),
                    Spree::Stock::Package::ContentItem.new(line_item3, variant3, 1)])
    end

    let(:package_with_invalid_weights) { double(Spree::Stock::Package,
          stock_location: stock_location,
          order: mock_model(Spree::Order, ship_address: us_address),
          contents: [Spree::Stock::Package::ContentItem.new(line_item5, variant5, 1),
                    Spree::Stock::Package::ContentItem.new(line_item6, variant6, 1)]) }

    let(:package_with_packages) do
      double(
        Spree::Stock::Package,
        order: mock_model(Spree::Order, ship_address: us_address),
        contents: [
          Spree::Stock::Package::ContentItem.new(line_item7, variant8, 4),
          Spree::Stock::Package::ContentItem.new(line_item8, variant7, 2)
        ],
        stock_location: stock_location
      )
    end

    let(:international_calculator) { Spree::Calculator::Shipping::Usps::PriorityMailInternational.new }
    let(:domestic_calculator) { Spree::Calculator::Shipping::Usps::PriorityMail.new }
    let(:multiplier) { Spree::ActiveShipping::Config[:unit_multiplier] }

    before(:each) do
      Rails.cache.clear
      Spree::ActiveShipping::Config.set(units: "imperial")
      Spree::ActiveShipping::Config.set(unit_multiplier: 16)
      Spree::ActiveShipping::Config.set(default_weight: 1)
    end

    describe "compute" do
      context "for international calculators" do
        it "should convert package contents to weights array for non-US countries (ex. Canada [limit = 66lbs])" do
          weights = international_calculator.send :convert_package_to_weights_array, package
          expect(weights).to eq [54.25, 65.25, 65.25, 65.25].map{ |x| x * multiplier }
        end

        it "should create array of packages" do
          packages = international_calculator.send :packages, package
          expect(packages.size).to eq(4)
          expect(packages.map{ |package| package.weight.amount }).to eq [54.25, 65.25, 65.25, 65.25].map{ |x| x * multiplier }
          expect(packages.map{ |package| package.weight.unit }.uniq).to eq [:ounces]
        end

        context "raise exception if max weight exceeded" do
          it "should get Spree::ShippingError" do
            allow(too_heavy_package).to receive(:weight) do
              too_heavy_package.contents.sum{ |item| item.variant.weight * item.quantity }
            end
            expect { international_calculator.compute(too_heavy_package) }.to raise_error(Spree::ShippingError)
          end
        end
      end

      context "for domestic calculators" do
        it "should not convert order line items to weights array for US" do
          weights = domestic_calculator.send :convert_package_to_weights_array, us_package
          expect(weights).to eq [54.25, 65.25, 65.25, 65.25].map{ |x| x * multiplier }
        end

        it "should create array with one package for US" do
          packages = domestic_calculator.send :packages, us_package
          expect(packages.size).to eq(4)
          expect(packages.map{ |package| package.weight.amount }).to eq [54.25, 65.25, 65.25, 65.25].map{ |x| x * multiplier }
          expect(packages.map{ |package| package.weight.unit }.uniq).to eq [:ounces]
        end
      end
    end

    describe "weight limits" do
      it "should be set for USPS calculators" do
        expect(international_calculator.send(:max_weight_for_country, country)).to eq(66.0 * multiplier) # Canada
        expect(domestic_calculator.send(:max_weight_for_country, country)).to eq(70.0 * multiplier)
      end

      it "should respect the max weight per package" do
        Spree::ActiveShipping::Config.set(max_weight_per_package: 30)
        weights = international_calculator.send :convert_package_to_weights_array, package
        expect(weights).to eq [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 25.25, 25.25, 25.25, 25.25, 29].map{ |x| x * multiplier }

        packages = international_calculator.send :packages, package
        expect(packages.size).to eq(11)
        expect(packages.map{ |package| package.weight.amount }).to eq [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 25.25, 25.25, 25.25, 25.25, 29].map{ |x| x * multiplier }
        expect(packages.map{ |package| package.weight.unit }.uniq). to eq [:ounces]
      end
    end

    describe "validation of line item weight" do
      it "should avoid zero weight or negative weight" do
        weights = domestic_calculator.send :convert_package_to_weights_array, package_with_invalid_weights
        default_weight = Spree::ActiveShipping::Config[:default_weight] * multiplier
        expect(weights).to eq [default_weight * 2]
      end
    end

    describe "validation of default weight of zero" do
      it "should accept zero default weight" do
        Spree::ActiveShipping::Config.set(default_weight: 0)
        weights = domestic_calculator.send :convert_package_to_weights_array, package_with_invalid_weights
        expect(weights).to eq [0]
      end
    end

    describe "adds item packages" do
      xit "should add item packages to weight calculation" do
        packages = domestic_calculator.send :packages, package_with_packages
        expect(packages.size).to eq(2)
        expect(packages.map{ |package| package.weight.amount }).to eq [21, 58, 36, 36, 43, 43].map{ |x| x * multiplier }
        expect(packages.map{ |package| package.weight.unit }.uniq).to eq([:ounces])
      end
    end
  end
end
