class ExamQuestion < ActiveRecord::Base
  self.table_name = 'training_exam_question'
  self.primary_key = 'exam_question_id'
  default_scope -> { order('exam_question_id') }

  before_save :default_active_values

  has_many :exam_question_details, foreign_key: "exam_question_id", class_name:  "ExamQuestionDetail", dependent: :destroy, :conditions => "training_exam_question_detail.active_flag = 1"
  belongs_to :subject, class_name: "Subject"
  belongs_to :level, class_name: "Level"
  accepts_nested_attributes_for :exam_question_details

  def number_question
    total = 0
    self.exam_question_details.each do |exam_question_detail|
      total = total + exam_question_detail.number_question
    end
    total
  end

  def all_exam_question_detail
    question_groups = self.subject.question_groups
    all_exam_question_details = []
    question_group_ids = []
    if !exam_question_details.nil?
      exam_question_details.each do |exam_question_detail|
        exam_question_detail.used = 1
        all_exam_question_details << exam_question_detail
        question_group_ids << exam_question_detail.question_group_id
      end
    end
    if !question_groups.nil?
      question_groups.each do |question_group|
        if question_group_ids.index(question_group.question_group_id).nil?
          exam_question_detail = ExamQuestionDetail.new(exam_question_id: self.exam_question_id, question_group_id: question_group.question_group_id,subject_id: self.subject_id, used: 0)
          all_exam_question_details << exam_question_detail
        end
      end
    end
    all_exam_question_details
  end

  def exam_question_detail?(question_group_id)
    if exam_question_details.nil?
      false
    else
      exist = false
      exam_question_details.each do |exam_question_detail|
        if exam_question_detail.question_group_id == question_group_id
          exist = true
        end
      end
      exist
    end
  end

  def default_active_values
    self.active_flag ||= 1
  end

end