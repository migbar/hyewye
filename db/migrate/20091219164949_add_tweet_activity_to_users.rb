class AddTweetActivityToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tweet_activity, :boolean, :default => true
  end

  def self.down
    remove_column :users, :tweet_activity
  end
end
