class AddEmailAndPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :email, :string, null: false, unique: true
    add_column :entities, :password_digest, :string, null: false
  end
end
