class ExamSessionDetail < ActiveRecord::Base
  self.table_name = 'training_exam_session_detail'
  self.primary_key = 'exam_session_detail_id'
  default_scope -> { order('no') }
  attr_accessor :used

  before_save :default_active_values

  belongs_to :exam_session, class_name: "ExamSession"
  belongs_to :subject, class_name: "Subject"

  def default_active_values
    self.active_flag ||= 1
  end
end