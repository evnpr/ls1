class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :devserver
      t.string :prodserver
      t.integer :app_id

      t.timestamps
    end
  end
end
