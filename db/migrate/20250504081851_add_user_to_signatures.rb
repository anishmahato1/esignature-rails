class AddUserToSignatures < ActiveRecord::Migration[7.1]
  def change
    add_reference :signatures, :user, null: false, foreign_key: true
  end
end
