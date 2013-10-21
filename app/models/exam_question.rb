class ExamQuestion < ActiveRecord::Base
  self.table_name = 'training_exam_question'
  self.primary_key = 'exam_question_id'
  default_scope -> { order('exam_question_id') }

  has_many :exam_question_details, foreign_key: "exam_question_id", class_name:  "ExamQuestionDetail", dependent: :destroy
  belongs_to :subject, class_name: "Subject"

  def number_question
    total = 0
    self.exam_question_details.each do |exam_question_detail|
      total = total + exam_question_detail.number_question
    end
    total
  end

end