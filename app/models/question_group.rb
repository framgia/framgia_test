class QuestionGroup < ActiveRecord::Base
  self.table_name = 'training_question_group'
  self.primary_key = 'question_group_id'
  default_scope -> { order('training_question_group.question_group_id') }

  before_create :default_active_values

  def default_active_values
    self.active_flag ||= 1
  end
end