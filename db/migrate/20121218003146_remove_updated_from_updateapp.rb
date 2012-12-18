class RemoveUpdatedFromUpdateapp < ActiveRecord::Migration
  def up
    remove_column :updateapps, :updated
      end

  def down
    add_column :updateapps, :updated, :string
  end
end
