class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :screen_name, :string
    add_column :users, :location, :string
  end

  def self.down
    remove_column :users, :location
    remove_column :users, :screen_name
  end
end
