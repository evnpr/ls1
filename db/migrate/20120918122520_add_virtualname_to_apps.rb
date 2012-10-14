class AddVirtualnameToApps < ActiveRecord::Migration
  def change
    add_column :apps, :virtual_name, :string

  end
end
