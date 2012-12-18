class AddUpdatedFromUpdateapp < ActiveRecord::Migration
  def change
    add_column :updateapps, :updated, :binary

  end
end
