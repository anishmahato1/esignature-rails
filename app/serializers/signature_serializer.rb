class SignatureSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :image_url

  def image_url
    return unless object.image.attached?

    Rails.application.routes.url_helpers.rails_blob_url object.image
  end
end
