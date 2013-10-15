class AnswerSheetDetail < ActiveRecord::Base
  self.table_name = 'training_answer_sheet_detail'
  self.primary_key = 'answer_sheet_detail_id'

  before_create :default_active_values

  belongs_to :answer_sheet, class_name: "AnswerSheet"
  belongs_to :question, class_name: "Question"
  belongs_to :answer, class_name: "Answer"

  def default_active_values
    self.active_flag ||= 1
  end
end