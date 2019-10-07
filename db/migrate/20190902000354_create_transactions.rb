class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :title
      t.string :description
      t.integer :amount
      t.datetime :transaction_date
      t.string :recurring_type
      t.timestamps null: false
    end
  end
end
