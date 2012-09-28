class CreateThedatabases < ActiveRecord::Migration
  def change
    create_table :thedatabases do |t|
      t.string :database_username
      t.string :database_name

      t.timestamps
    end
  end
end
