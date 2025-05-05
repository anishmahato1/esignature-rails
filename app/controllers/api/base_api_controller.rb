module Api
  class BaseApiController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

    include RequestTracking

    before_action :authenticate_user!

    attr_reader :current_user

    private

    def authenticate_user!
      header = request.headers['Authorization']
      token = header.split.last if header

      if token
        decoded = JsonWebToken.decode(token)
        @current_user = User.find_by(id: decoded[:user_id]) if decoded
      end

      render_error('Not Authorized', :unauthorized) unless @current_user
    end

    def not_found
      render_error 'Record not found', :not_found
    end

    def unprocessable_entity(exception)
      render_error exception.record.errors.full_messages
    end

    #
    # Generic error rendering method
    #
    def render_error(message, status = :unprocessable_entity)
      render json: { error: message }, status: status
    end
  end
end
