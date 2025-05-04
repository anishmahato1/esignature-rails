class Document < ApplicationRecord
  VALID_CONTENT_TYPES = ['application/pdf'].freeze
  MAX_FILE_SIZE = 100.megabytes

  enum :status, {
    pending: 0, # when document is uploaded but not signed ( default )
    signed: 1,  # when document is signed
    failed: 2   # when document is failed to be signed, can be signed again
  }

  validates :title, presence: true
  validates :file, attached: true,
                   content_type: VALID_CONTENT_TYPES,
                   size: {
                     less_than: MAX_FILE_SIZE,
                     # TODO: use i18n
                     message: "Document size must be less than #{MAX_FILE_SIZE}"
                   }

  belongs_to :user
  has_one :document_signature, dependent: :destroy

  has_one_attached :file


  #
  # Check if document can be signed
  #
  # @return [Boolean] true if document can be signed, false otherwise
  #
  def can_be_signed?
    pending? || failed?
  end
end
