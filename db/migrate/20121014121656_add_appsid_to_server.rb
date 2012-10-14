class AddAppsidToServer < ActiveRecord::Migration
  def change
    add_column :servers, :apps_id, :integer

  end
end
