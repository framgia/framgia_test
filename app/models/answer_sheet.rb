class AnswerSheet < ActiveRecord::Base
  self.table_name = 'training_answer_sheet'
  self.primary_key = 'answer_sheet_id'
  default_scope -> { order('no') }

  before_create :default_active_values
  before_update :set_exam_result_values

  has_many :answer_sheet_details, foreign_key: "answer_sheet_id", class_name: "AnswerSheetDetail", dependent: :destroy
  belongs_to :user, class_name: "User"
  belongs_to :exam_question, class_name: "ExamQuestion"
  belongs_to :examination, class_name: "Examination"
  belongs_to :subject, class_name: "Subject"
  accepts_nested_attributes_for :answer_sheet_details

  def default_active_values
    self.active_flag ||= 1
  end

  def set_exam_result_values
    total = 0
    answer_sheet_details.each do |answer_sheet_detail|
      if answer_sheet_detail.answer_correct == 1 || (!answer_sheet_detail.answer.nil? && answer_sheet_detail.question.answer_type == 1 && answer_sheet_detail.answer.answer_correct == 1)
        total = total + 1
      end
    end
    self.exam_result = total
  end

  def limit_time?
    (Time.now.to_i - self.started_at.to_i) > self.exam_question.exam_time
  end

  def limit_time
    timed = Time.now.to_i - self.started_at.to_i
    self.exam_question.exam_time > timed ? self.exam_question.exam_time - timed : 0
  end

end