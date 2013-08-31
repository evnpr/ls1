class RemoveSftplocationFromApps < ActiveRecord::Migration
  def up
    remove_column :apps, :sftp_location
      end

  def down
    add_column :apps, :sftp_location, :string
  end
end
