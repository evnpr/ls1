class AddCommitmessageToNotifs < ActiveRecord::Migration
  def change
    add_column :notifs, :commit_message, :string

  end
end
