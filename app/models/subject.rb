class Subject < ActiveRecord::Base
  self.table_name = 'training_subject'
  self.primary_key = 'subject_id'
  default_scope -> { order('subject_id') }

  has_many :subject_question_groups, foreign_key: "subject_id", class_name: "SubjectQuestionGroup"
  has_many :question_groups, through: :subject_question_groups, source: :question_group, class_name: "QuestionGroup"
end