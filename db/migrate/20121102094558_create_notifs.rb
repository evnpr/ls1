class CreateNotifs < ActiveRecord::Migration
  def change
    create_table :notifs do |t|
      t.string :name
      t.string :commiter
      t.integer :apps_id

      t.timestamps
    end
  end
end
