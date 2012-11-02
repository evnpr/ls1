class CreateTableAppsNotif < ActiveRecord::Migration
  def up
    create_table :apps_notifs do |t|
      t.integer :apps_id
      t.integer :notif_id

      t.timestamps
    end
  end

  def down
  end
end
