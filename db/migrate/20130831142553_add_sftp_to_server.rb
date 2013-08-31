class AddSftpToServer < ActiveRecord::Migration
  def change
    add_column :servers, :sftp_username, :string

    add_column :servers, :sftp_password, :string

    add_column :servers, :sftp_host, :string

  end
end
