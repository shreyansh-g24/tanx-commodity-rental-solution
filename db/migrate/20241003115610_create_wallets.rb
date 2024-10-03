class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.string :cryptocurrency, null: false
      t.float :balance, default: 0, null: false
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end

    add_index :wallets, [:user, :cryptocurrency], unique: true
  end
end
