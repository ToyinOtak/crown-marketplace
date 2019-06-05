module SpecSupport
  module StubAuth
    def stub_auth_st
      user = FactoryBot.create(:user, roles: %i[buyer st_access])
      login_as(user, scope: :user)
    end

    def stub_auth_mc
      user = FactoryBot.create(:user, roles: %i[buyer mc_access])
      login_as(user, scope: :user)
    end

    def stub_dfe
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:dfe] = OmniAuth::AuthHash.new(
        'provider' => 'dfe',
        'info' => { 'email' => 'dfe@example.com' },
        'extra' => {
          'raw_info' => {
            'organisation' => {
              'id' => '047F32E7-FDD5-46E9-89D4-2498C2E77364',
              'name' => 'St Custard’s',
              'urn' => '900002',
              'ukprn' => '90000002',
              'category' => {
                'id' => '001',
                'name' => 'Establishment'
              },
              'type' => {
                'id' => '01',
                'name' => 'Community school'
              }
            }
          }
        }
      )
    end

    def unstub_auth
      Warden.test_reset!
    end
  end
end

RSpec.configure do |config|
  config.include SpecSupport::StubAuth, type: :feature
  config.around(:example, type: :feature, supply_teachers: true) do |example|
    stub_auth_st
    example.run
    unstub_auth
  end
  config.around(:example, type: :feature, management_consultancy: true) do |example|
    stub_auth_mc
    example.run
    unstub_auth
  end
  config.around(:example, type: :feature, dfe: true) do |example|
    stub_dfe
    example.run
  end
end
