class SubjectQuestionGroup < ActiveRecord::Base
  self.table_name = 'training_subject_question_group'
  self.primary_key = 'subject_question_group_id'
  belongs_to :subject, class_name: "Subject", foreign_key: "subject_id"
  belongs_to :question_group, class_name: "QuestionGroup", foreign_key: "question_group_id"
  validates :subject_id, presence: true
  validates :question_group_id, presence: true
end