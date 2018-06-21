RSpec.describe Spree::Calculator::Shipping::Ups::WorldwideExpress do
  subject { Spree::Calculator::Shipping::Ups::WorldwideExpress }

  let(:application_locale) { :en }

  before { I18n.locale = application_locale }

  describe '.description' do
    context 'when :locale is not send' do
      let(:expected) { I18n.t('ups.worldwide_express', locale: application_locale) }

      it 'should return the description translated using the application locale' do
        expect(subject.description).to eq(expected)
      end
    end

    context 'when :locale is send' do
      let(:locale) { :es }
      let(:expected) { I18n.t('ups.worldwide_express', locale: locale) }

      it 'should return the description translated using the locale param' do
        expect(subject.description(locale: locale)).to eq(expected)
      end
    end
  end

  describe '#rate_result_key' do
    subject { Spree::Calculator::Shipping::Ups::WorldwideExpress.new }

    let(:expected) { I18n.t('ups.worldwide_express', locale: :en) }

    context 'when application locale is :en' do
      it 'should return the description in english' do
        expect(subject.send(:rate_result_key)).to eq(expected)
      end
    end

    context 'when application locale is :es' do
      it 'should return the description in english' do
        expect(subject.send(:rate_result_key)).to eq(expected)
      end
    end
  end
end
