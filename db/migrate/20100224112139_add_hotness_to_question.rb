class AddHotnessToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :hotness, :float, :default => 1.0
    add_column :questions, :last_answered_at, :datetime
  end

  def self.down
    remove_column :questions, :last_answered_at
    remove_column :questions, :hotness
  end
end
