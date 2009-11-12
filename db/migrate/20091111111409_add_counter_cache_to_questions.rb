class AddCounterCacheToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :answers_count, :integer, :default => 0
    Question.reset_column_information
    Question.all.each do |question|
      count = Answer.count(:all, :conditions => ["question_id = ?", question.id])
      Question.update_all("answers_count = #{count}", "id = #{question.id}")
    end
  end

  def self.down
    remove_column :questions, :answers_count
  end
end
