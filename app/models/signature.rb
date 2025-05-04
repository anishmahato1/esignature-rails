class Signature < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = ['image/png', 'image/jpeg', 'image/jpg'].freeze

  belongs_to :user
  has_many :document_signatures, dependent: :destroy
  has_many :documents, through: :document_signatures
  has_one_attached :image

  validates :name, presence: true
  validates :image, attached: true,
                    content_type: ACCEPTED_CONTENT_TYPES,
                    size: {
                      less_than: 2.megabytes,
                      # TODO: use i18n
                      message: 'Signature image must be less than 2MB'
                    }

  before_create :set_signed_at

  private

  def set_signed_at
    self.signed_at = Time.current
  end
end
