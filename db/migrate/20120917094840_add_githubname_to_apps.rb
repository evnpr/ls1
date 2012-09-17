class AddGithubnameToApps < ActiveRecord::Migration
  def change
    add_column :apps, :githubname, :string

    add_column :apps, :githubproject, :string

  end
end
