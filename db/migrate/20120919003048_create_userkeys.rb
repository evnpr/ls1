class CreateUserkeys < ActiveRecord::Migration
  def change
    create_table :userkeys do |t|
      t.text :userkey
      t.integer :user_id

      t.timestamps
    end
  end
end
