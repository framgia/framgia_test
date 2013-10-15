class ExamQuestionDetail < ActiveRecord::Base
  self.table_name = 'training_exam_question_detail'
  self.primary_key = 'exam_question_detail_id'
  default_scope -> { order('no') }

  belongs_to :exam_question, class_name: "ExamQuestion"
  belongs_to :subject, class_name: "Subject"
  belongs_to :question_group, class_name: "QuestionGroup"
end