class Document < ApplicationRecord
  enum :status, {
    pending: 0, # when document is uploaded but not signed ( default )
    signed: 1,  # when document is signed
    failed: 2   # when document is failed to be signed, can be signed again
  }

  validates :title, presence: true
  validates :file, presence: true, content_type: ['application/pdf']

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
