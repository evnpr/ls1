class RemoveCommiterFromNotif < ActiveRecord::Migration
  def up
    remove_column :notifs, :commiter
      end

  def down
    add_column :notifs, :commiter, :string
  end
end
