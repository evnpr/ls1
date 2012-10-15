class AddDevurlToServer < ActiveRecord::Migration
  def change
    add_column :servers, :devurl, :string

    add_column :servers, :produrl, :string

  end
end
