class User < ApplicationRecord
  has_secure_password
  has_many :documents, dependent: :destroy
  has_many :signatures, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :password, length: { minimum: 8 }

  before_validation :squish_name_and_email_spaces!, :set_default_name

  private

  #
  # Strips white spaces at ends and any extras in between
  #
  def squish_name_and_email_spaces!
    [name, email].each { |attr| attr&.squish! }
  end

  #
  # Sets the name to the email if it's not set
  #
  def set_default_name
    self.name ||= email&.split('@')&.first
  end
end
