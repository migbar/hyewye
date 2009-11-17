class RenameTargetToSubject < ActiveRecord::Migration
  def self.up
    rename_column :events, :target_id, :subject_id
    rename_column :events, :target_type, :subject_type
  end

  def self.down
    rename_column :events, :subject_id, :target_id
    rename_column :events, :subject_type, :target_type
  end
end
