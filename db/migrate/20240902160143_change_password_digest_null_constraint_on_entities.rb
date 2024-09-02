class ChangePasswordDigestNullConstraintOnEntities < ActiveRecord::Migration[7.0]
  def change
    change_column_null :entities, :password_digest, true
  end
end
