class AddSftplocationToServer < ActiveRecord::Migration
  def change
    add_column :servers, :sftp_location, :string

  end
end
