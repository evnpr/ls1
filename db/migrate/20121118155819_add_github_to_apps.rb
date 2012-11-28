class AddGithubToApps < ActiveRecord::Migration
  def change
    add_column :apps, :githubrepo, :integer, :null => false, :default => 1

  end
end
