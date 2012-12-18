class AddUpdateddFromUpdateapp < ActiveRecord::Migration
  def change
    add_column :updateapps, :updated, :boolean

  end
end
