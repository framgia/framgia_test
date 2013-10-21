class AddFields < ActiveRecord::Migration
  def change
    add_column :training_question, :description, :string, limit: 128
    add_column :training_exam_question, :exam_time, :integer
  end
end
