class CreateUpdateapps < ActiveRecord::Migration
  def change
    create_table :updateapps do |t|
      t.integer :apps_id
      t.binary :update

      t.timestamps
    end
  end
end
