class AddAppsidToThedatabase < ActiveRecord::Migration
  def change
    add_column :thedatabases, :apps_id, :integer

  end
end
