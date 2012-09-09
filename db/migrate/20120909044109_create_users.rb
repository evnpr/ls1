class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
      t.text :userkey, :limit => 10000

      t.timestamps
    end
  end
end
