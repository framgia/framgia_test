class Subject < ActiveRecord::Base
  self.table_name = 'training_subject'
  self.primary_key = 'subject_id'
  default_scope -> { order('subject_id') }

  has_many :subject_group, foreign_key: "subject_id", class_name: "SubjectQuestionGroup"
  has_many :groups, through: :subject_group, source: :question_group
end