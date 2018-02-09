class ChangeIsOwnerDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :isOwner, false
  end
end
