module Api
  module V1
    class SessionsController < Api::BaseApiController
      skip_before_action :authenticate_user!

      def create
        user = User.find_by! email: params[:email]
        return render_error('Invalid password', :unauthorized) unless user.authenticate params[:password]

        token = JsonWebToken.encode user_id: user.id

        render json: user, meta: { token: token }, status: :ok
      end
    end
  end
end
