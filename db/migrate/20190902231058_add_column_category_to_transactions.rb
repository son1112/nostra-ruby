class AddColumnCategoryToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :category, :string
  end
end
