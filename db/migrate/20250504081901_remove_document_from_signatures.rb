class RemoveDocumentFromSignatures < ActiveRecord::Migration[7.1]
  def change
    remove_reference :signatures, :document, null: false, foreign_key: true
  end
end
