module Api
  module V1
    class SignaturesController < Api::BaseApiController
      before_action :set_signature, only: %i[show destroy]

      # GET /api/v1/signatures
      def index
        @signatures = current_user.signatures

        render json: @signatures
      end

      # GET /api/v1/signatures/:id
      def show
        render json: @signature
      end

      # POST /api/v1/signatures
      def create
        # validation errors rescued from base_api_controller
        @signature = current_user.signatures.create!(signature_params)

        render json: @signature, status: :created
      end

      # TODO: add update action when needed

      # DELETE /api/v1/signatures/:id
      def destroy
        @signature.destroy

        head :no_content
      end

      private

      def set_signature
        @signature = current_user.signatures.find!(params[:id])
      end

      def signature_params
        params.require(:signature).permit(:name, :image)
      end
    end
  end
end
