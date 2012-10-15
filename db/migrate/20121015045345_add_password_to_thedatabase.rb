class AddPasswordToThedatabase < ActiveRecord::Migration
  def change
    add_column :thedatabases, :database_pwd, :string

  end
end
