class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events, :force => true do |t|
      t.references :target
      t.string :target_type
      t.timestamps
    end
    
    add_index :events, :target_id
    add_index :events, :target_type
    add_index :events, [:target_id, :target_type]
  end

  def self.down
    drop_table :events
  end
end
