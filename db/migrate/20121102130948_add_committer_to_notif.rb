class AddCommitterToNotif < ActiveRecord::Migration
  def change
    add_column :notifs, :committer, :string

  end
end
