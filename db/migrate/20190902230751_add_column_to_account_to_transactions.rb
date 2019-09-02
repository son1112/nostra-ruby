class AddColumnToAccountToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :to_account, :string
  end
end
