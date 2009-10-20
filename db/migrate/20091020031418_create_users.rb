class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :login,               :null => false
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
  
      t.timestamps
    end
    
    add_index :users, :login
    add_index :users, :email
    add_index :users, :persistence_token
    add_index :users, :single_access_token
    add_index :users, :perishable_token
  end

  def self.down
    drop_table :users
  end
end
