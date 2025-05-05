class Signature < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = ['image/png', 'image/jpeg', 'image/jpg'].freeze
  MAX_IMAGE_SIZE = 2.megabytes

  belongs_to :user
  has_many :document_signatures, dependent: :destroy
  has_many :documents, through: :document_signatures
  has_one_attached :image

  validates :name, presence: true
  validates :image, attached: true,
                    content_type: ACCEPTED_CONTENT_TYPES,
                    size: {
                      less_than: MAX_IMAGE_SIZE,
                      # TODO: use i18n
                      message: "Signature image must be less than #{MAX_IMAGE_SIZE}"
                    }
end
