class DocumentSignature < ApplicationRecord
  validates :page_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :x_position, :y_position, :width, :height, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :document
  belongs_to :signature

  before_create :set_signed_at

  private

  def set_signed_at
    self.signed_at = Time.current
  end

end
