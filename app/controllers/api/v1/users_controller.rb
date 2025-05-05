module Api
  module V1
    class UsersController < Api::BaseApiController
      skip_before_action :authenticate_user!

      # POST /api/v1/sign_up
      def create
        # invalid records rescued from base_api_controller
        user = User.create!(user_params)

        token = JsonWebToken.encode(user_id: user.id)

        render json: user, meta: { token: token }, status: :created
      end

      private

      def user_params
        params.require(:user)
              .permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
