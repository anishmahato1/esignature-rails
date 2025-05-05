module Api
  module V1
    class DocumentsController < Api::BaseApiController
      before_action :set_document, only: %i[show destroy download_signed]

      # GET /api/v1/documents
      def index
        @documents = current_user.documents
                                 .with_attached_file
                                 .includes(:document_signature)

        render json: @documents
      end

      # GET /api/v1/documents/:id
      def show
        render json: @document
      end

      # POST /api/v1/documents
      def create
        # validation errors rescued from base_api_controller
        @document = current_user.documents.create!(document_params)

        render json: @document, status: :created
      end

      # TODO: add update action when needed

      # DELETE /api/v1/documents/:id
      def destroy
        @document.destroy!

        head :no_content
      end

      # GET /api/v1/documents/:id/download_signed
      def download_signed
        return render_error('Document has not been signed yet', :unprocessable_entity) unless @document.signed?

        redirect_to rails_blob_url(@document.file)
      end

      private

      def set_document
        @document = current_user.documents.find params[:id]
      end

      def document_params
        params.permit(:title, :file)
      end
    end
  end
end
