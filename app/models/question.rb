class Question < ActiveRecord::Base
  self.table_name = 'training_question'
  self.primary_key = 'question_id'

  has_many :answers, foreign_key: "question_id", class_name:  "Answer", dependent: :destroy
  belongs_to :subject, class_name: "Subject"
  belongs_to :question_group, class_name: "QuestionGroup"

end