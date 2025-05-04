class RemoveColumnsFromSignatures < ActiveRecord::Migration[7.1]
  def change
    remove_column :signatures, :page_number, :integer
    remove_column :signatures, :x_position, :float
    remove_column :signatures, :y_position, :float
    remove_column :signatures, :width, :float
    remove_column :signatures, :height, :float
  end
end
