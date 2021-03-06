require 'rails_helper'

RSpec.describe ManagementConsultancy::SupplierSpreadsheetCreator do
  let(:supplier) { create(:management_consultancy_supplier) }
  let(:suppliers) { ManagementConsultancy::Supplier.where(id: supplier.id) }
  let(:lot_number) { 'MCF1.2' }
  let(:lot) { ManagementConsultancy::Lot.find_by(number: lot_number) }
  let(:services) { ManagementConsultancy::Service.all.sample(5).map(&:code) }
  let(:region_codes) { Nuts2Region.all.sample(5).map(&:code) }
  let(:params) { { 'region_codes' => region_codes, 'services' => services, 'lot' => lot_number } }
  let(:spreadsheet_creator) { described_class.new(suppliers, params) }

  before do
    allow(ManagementConsultancy::Supplier).to receive(:offering_services_in_regions)
      .with(lot_number, services, region_codes).and_return(suppliers)
  end

  describe '.build' do
    it 'returns an Axlsx::Package' do
      spreadsheet = spreadsheet_creator.build
      expect(spreadsheet.class).to eq(Axlsx::Package)
    end
  end
end
