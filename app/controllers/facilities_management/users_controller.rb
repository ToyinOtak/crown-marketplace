module FacilitiesManagement
  class UsersController < Base::UsersController
    private

    def new_challenge_path
      facilities_management_users_challenge_path(challenge_name: @challenge.new_challenge_name, session: @challenge.new_session, username: params[:username])
    end

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || facilities_management_journey_start_path
    end
  end
end
