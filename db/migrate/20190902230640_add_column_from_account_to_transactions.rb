class AddColumnFromAccountToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :from_account, :string
  end
end
