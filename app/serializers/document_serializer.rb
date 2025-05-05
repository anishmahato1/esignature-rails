class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :created_at, :updated_at, :file_url

  def file_url
    return unless object.file.attached?

    Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true)
  end
end
