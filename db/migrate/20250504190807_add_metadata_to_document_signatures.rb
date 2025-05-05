class AddMetadataToDocumentSignatures < ActiveRecord::Migration[7.1]
  def change
    add_column :document_signatures, :metadata, :jsonb
  end
end
