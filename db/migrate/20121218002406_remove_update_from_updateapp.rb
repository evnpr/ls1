class RemoveUpdateFromUpdateapp < ActiveRecord::Migration
  def up
    remove_column :updateapps, :update
      end

  def down
    add_column :updateapps, :update, :string
  end
end
