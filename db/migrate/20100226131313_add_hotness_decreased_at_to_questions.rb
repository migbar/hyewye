class AddHotnessDecreasedAtToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :hotness_decreased_at, :datetime
  end

  def self.down
    remove_column :questions, :hotness_decreased_at
  end
end
