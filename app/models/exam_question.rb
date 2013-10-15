class ExamQuestion < ActiveRecord::Base
  self.table_name = 'training_exam_question'
  self.primary_key = 'exam_question_id'

  has_many :exam_question_details, foreign_key: "exam_question_id", class_name:  "ExamQuestionDetail", dependent: :destroy
  belongs_to :subject, class_name: "Subject"

end