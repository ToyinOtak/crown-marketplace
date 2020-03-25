module ManagementConsultancy
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user

    protected

    def authorize_user
      authorize! :read, ManagementConsultancy
    end

    protected

    def authorize_user
      authorize! :read, ManagementConsultancy
    end
  end
end
