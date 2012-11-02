class CreateNotifsUsers < ActiveRecord::Migration
  def change
    create_table :notifs_users do |t|
      t.integer :notif_id
      t.integer :user_id

      t.timestamps
    end
  end
end
