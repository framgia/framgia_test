class Examination < ActiveRecord::Base
  self.table_name = 'training_examination'
  self.primary_key = 'examination_id'
  default_scope -> { order('created_at DESC') }

  before_create :default_active_values

  has_many :examination_details, foreign_key: "examination_id", class_name:  "ExaminationDetail", dependent: :destroy
  has_many :answer_sheets, foreign_key: "examination_id", class_name:  "AnswerSheet", dependent: :destroy
  belongs_to :user, class_name: "User"
  belongs_to :conclusion, class_name: "Conclusion"
  accepts_nested_attributes_for :answer_sheets
  def first_answer_sheet
    answer_sheets.find_by(no: 1)
  end

  def default_active_values
    self.active_flag ||= 1
  end

  def self.from_users
    examination_ids = "SELECT MAX(examination_id) FROM training_examination
                         GROUP BY user_id"
    where("examination_id IN (#{examination_ids})", examination_ids: examination_ids)
  end

end