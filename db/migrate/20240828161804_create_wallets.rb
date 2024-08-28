class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :entity, null: false, foreign_key: true
      t.decimal :balance, precision: 15, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
