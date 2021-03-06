require 'rails_helper'

RSpec.describe SupplyTeachers::Journey::AgencyPayroll, type: :model do
  subject(:step) do
    described_class.new(
      postcode: postcode,
      term: SupplyTeachers::Term.all.first,
      job_type: SupplyTeachers::JobType.roles.first
    )
  end

  let(:model_key) { 'activemodel.errors.models.supply_teachers/journey/agency_payroll' }

  let(:postcode) { valid_fake_postcode }

  before do
    Geocoder::Lookup::Test.add_stub(
      postcode, [{ 'coordinates' => [51.5149666, -0.119098] }]
    )
  end

  after do
    Geocoder::Lookup::Test.reset
  end

  it { is_expected.to be_valid }

  context 'when location is not valid' do
    before do
      step.postcode = 'XY1 2AB'
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:location]).to include(
        I18n.t("#{model_key}.attributes.location.invalid_location")
      )
    end
  end
end
