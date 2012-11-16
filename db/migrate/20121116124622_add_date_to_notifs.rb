class AddDateToNotifs < ActiveRecord::Migration
  def change
    add_column :notifs, :date, :string

  end
end
