class AddAppsidToNotifsUsers < ActiveRecord::Migration
  def change
    add_column :notifs_users, :apps_id, :integer

  end
end
