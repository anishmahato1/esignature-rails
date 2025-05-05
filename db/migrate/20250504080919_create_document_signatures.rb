class CreateDocumentSignatures < ActiveRecord::Migration[7.1]
  def change
    create_table :document_signatures do |t|
      t.references :document, null: false, foreign_key: true
      t.references :signature, null: false, foreign_key: true
      t.integer :page_number
      t.float :x_position
      t.float :y_position
      t.float :width
      t.float :height
      t.datetime :signed_at

      t.timestamps
    end
  end
end
