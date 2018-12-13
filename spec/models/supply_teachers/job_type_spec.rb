require 'rails_helper'

RSpec.describe SupplyTeachers::JobType, type: :model do
  subject(:job_types) { described_class.all }

  let(:first_job_type) { job_types.first }
  let(:non_role_job_type) { described_class.find_by(code: 'fixed_term') }

  it 'loads job_types from CSV' do
    expect(job_types.count).to eq(11)
  end

  it 'populates attributes of first job_type' do
    expect(first_job_type.code).to eq('qt')
    expect(first_job_type.description).to eq('Qualified teacher: non-SEN roles')
  end

  describe '.[]' do
    it 'looks up job type description by code' do
      expect(described_class[first_job_type.code]).to eq(first_job_type.description)
    end
  end

  describe '.find_role_by' do
    it 'looks up role job type by code' do
      expect(described_class.find_role_by(code: first_job_type.code)).to eq(first_job_type)
    end

    it 'does not find non-role job type' do
      expect(described_class.find_role_by(code: non_role_job_type.code)).to be_nil
    end
  end

  describe '.roles' do
    it 'returns all role job types' do
      expect(described_class.roles.count).to eq(8)
      expect(described_class.roles).to include(first_job_type)
    end

    it 'does not include non-role job type' do
      expect(described_class.roles).not_to include(non_role_job_type)
    end
  end

  describe '.all_codes' do
    it 'returns codes for all services' do
      expect(described_class.all_codes.count).to eq(job_types.count)
      expect(described_class.all_codes.first).to eq(first_job_type.code)
    end
  end
end