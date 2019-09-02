class AddColumnAmount2ToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :amount_2, :string
  end
end
