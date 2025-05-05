class CreateSignatures < ActiveRecord::Migration[7.1]
  def change
    create_table :signatures do |t|
      t.references :document, null: false, foreign_key: true
      t.integer :page_number, null: false
      t.float :x_position, null: false
      t.float :y_position, null: false
      t.float :width, null: false
      t.float :height, null: false

      t.timestamps
    end
  end
end
