class AddSftpToApps < ActiveRecord::Migration
  def change
    add_column :apps, :sftp_location, :string

    add_column :apps, :type_server, :string

  end
end
