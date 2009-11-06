class AddUserIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :user_id, :integer
    add_index :events, :user_id
    
    Event.reset_column_information
    Event.all.each do |event|
      event.update_attribute(:user_id, event.target.user_id)
    end
  end

  def self.down
    remove_column :events, :user_id
  end
end
