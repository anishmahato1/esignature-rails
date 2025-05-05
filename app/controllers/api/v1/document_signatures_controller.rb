module Api
  module V1
    class DocumentSignaturesController < Api::BaseApiController
      before_action :set_document

      # POST /api/v1/documents/:id/sign_document
      def create
        # check if document can be signed
        return render_error('Document is already signed') if @document.signed?

        # find the signature
        signature = current_user.signatures.find(params[:signature_id])

        creation_params = document_signature_params.merge(
          signature: signature,
          metadata: capture_request_metadata
        )

        # create document signature with metadata captured only for this action
        @document.create_document_signature! creation_params

        @document.reload

        render json: @document, status: :created
      end

      private

      def set_document
        @document = current_user.documents.find params[:id]
      end

      def document_signature_params
        params.permit(:page_number, :x_position, :y_position, :width, :height)
      end
    end
  end
end
