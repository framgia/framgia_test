class ExaminationDetail < ActiveRecord::Base
  self.table_name = 'training_examination_detail'
  self.primary_key = 'examination_detail_id'

  belongs_to :examination, class_name: "Examination"
  belongs_to :exam_question, class_name: "ExamQuestion"
end