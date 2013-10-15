class AnswerSheet < ActiveRecord::Base
  self.table_name = 'training_answer_sheet'
  self.primary_key = 'answer_sheet_id'
  default_scope -> { order('answer_sheet_id') }

  before_create :default_active_values

  has_many :answer_sheet_details, foreign_key: "answer_sheet_id", class_name: "AnswerSheetDetail", dependent: :destroy
  belongs_to :user, class_name: "User"
  belongs_to :exam_question, class_name: "ExamQuestion"
  belongs_to :examination, class_name: "Examination"
  belongs_to :subject, class_name: "Subject"
  accepts_nested_attributes_for :answer_sheet_details

  def default_active_values
    self.active_flag ||= 1
  end
end