class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :created_at, :file_url
  attribute :audit_info, if: :signed_with_signature?

  def file_url
    return unless object.file.attached?

    Rails.application.routes.url_helpers.rails_blob_url object.file
  end

  def audit_info
    document_signature = object.document_signature

    {
      signed_at: document_signature.signed_at,
      **extract_metadata(document_signature)
    }
  end

  def signed_with_signature?
    object.signed? && object.document_signature.present?
  end

  private

  def extract_metadata(document_signature)
    document_signature.metadata
                      .to_h # in case metadata is nil
                      .slice('ip', 'browser', 'os', 'location', 'user_agent')
  end
end
