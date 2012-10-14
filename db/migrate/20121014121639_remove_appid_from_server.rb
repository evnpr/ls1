class RemoveAppidFromServer < ActiveRecord::Migration
  def up
    remove_column :servers, :app_id
      end

  def down
    add_column :servers, :app_id, :integer
  end
end
