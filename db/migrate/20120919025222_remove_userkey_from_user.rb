class RemoveUserkeyFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :userkey
      end

  def down
    add_column :users, :userkey, :text
  end
end
