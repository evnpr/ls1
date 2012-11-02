class CreateNotifreads < ActiveRecord::Migration
  def change
    create_table :notifreads do |t|
      t.integer :user_id
      t.integer :notif_id

      t.timestamps
    end
  end
end
