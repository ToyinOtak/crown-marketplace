require 'rails_helper'

RSpec.describe Cognito::ConfirmSignUp do
  describe '#call' do
    let(:email) { 'user@test.com' }
    let(:user) { create(:user, email: email, confirmed_at: nil) }
    let(:confirmation_code) { '12345' }
    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    context 'when success' do
      let(:response) { described_class.call(user.email, confirmation_code) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:confirm_sign_up).and_return(JSON[{ user_sub: '1234'.to_json }])
        response
      end

      it 'returns success' do
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        expect(response.error).to eq nil
      end

      it 'confirms user' do
        user.reload
        expect(user.confirmed?).to eq true
      end
    end

    context 'when cognito error' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:confirm_sign_up).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('oops', 'Oops'))
      end

      it 'does not return success' do
        response = described_class.call(user.email, confirmation_code)
        expect(response.success?).to eq false
      end

      it 'does returns cognito error' do
        response = described_class.call(user.email, confirmation_code)
        expect(response.error).to eq 'Oops'
      end

      it 'does not confirm user' do
        user.reload
        expect(user.confirmed?).to eq false
      end
    end
  end
end