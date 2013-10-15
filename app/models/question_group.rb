class QuestionGroup < ActiveRecord::Base
  self.table_name = 'training_question_group'
  self.primary_key = 'question_group_id'
  default_scope -> { order('question_group_id') }
end