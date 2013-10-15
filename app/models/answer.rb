class Answer < ActiveRecord::Base
  self.table_name = 'training_answer'
  self.primary_key = 'answer_id'

  belongs_to :question, class_name: "Question"
end