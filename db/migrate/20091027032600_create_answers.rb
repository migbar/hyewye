class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.references :user
      t.references :question
      
      t.integer :choice
      t.string :body

      t.timestamps
    end
    
    add_index :answers, :user_id
    add_index :answers, :question_id
  end

  def self.down
    drop_table :answers
  end
end
