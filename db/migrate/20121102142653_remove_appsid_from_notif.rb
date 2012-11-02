class RemoveAppsidFromNotif < ActiveRecord::Migration
  def up
    remove_column :notifs, :apps_id
      end

  def down
    add_column :notifs, :apps_id, :string
  end
end
