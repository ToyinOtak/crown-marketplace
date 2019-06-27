module Cognito
  class SignInUser < BaseService
    include ActiveModel::Validations
    attr_reader :email, :password
    attr_accessor :error

    validates_presence_of :email, :password

    def initialize(email, password)
      @email = email
      @password = password
      @error = nil
    end

    def call
      initiate_auth
    rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
      @error = e.message
      errors.add(:base, e.message)
    end

    def challenge?
      @auth_response.challenge_name.present?
    end

    def cognito_uuid
      @auth_response.challenge_parameters['USER_ID_FOR_SRP']
    end

    def session
      @auth_response.session
    end

    def challenge_name
      @auth_response.challenge_name
    end

    private

    def initiate_auth
      @auth_response = client.initiate_auth(
        client_id: ENV['COGNITO_CLIENT_ID'],
        auth_flow: 'USER_PASSWORD_AUTH',
        auth_parameters: {
          'USERNAME' => email,
          'PASSWORD' => password
        }
      )
    end
  end
end