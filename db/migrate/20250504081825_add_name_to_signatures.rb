class AddNameToSignatures < ActiveRecord::Migration[7.1]
  def change
    add_column :signatures, :name, :string
  end
end
