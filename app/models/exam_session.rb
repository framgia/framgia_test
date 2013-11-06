class ExamSession < ActiveRecord::Base
  self.table_name = 'training_exam_session'
  self.primary_key = 'exam_session_id'
  default_scope -> { order('exam_date DESC') }

  attr_accessor :subject_ids

  before_save :default_active_values
  after_save :make_exam_session_details

  has_many :exam_session_details, foreign_key: "exam_session_id", class_name:  "ExamSessionDetail", dependent: :destroy, :conditions => "training_exam_session_detail.active_flag = 1"
  belongs_to :level, class_name: "Level"
  accepts_nested_attributes_for :exam_session_details

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

  def make_exam_session_details
    exam_session_detail_map = {}
    _exam_session_details = []
    if !self.exam_session_id.nil?
      _exam_session_details = ExamSessionDetail.where(exam_session_id: self.exam_session_id, active_flag: 1)
    end
    if !_exam_session_details.nil? && !_exam_session_details.empty?
      _exam_session_details.each do |exam_session_detail|
        exam_session_detail_map[exam_session_detail.subject_id] = exam_session_detail
      end
    end
    if !self.subject_ids.nil? && !self.subject_ids.empty?
      index = 1
      self.subject_ids.each do |subject_id|
        if subject_id.nil? || subject_id.empty?
          next
        end
        if exam_session_detail_map.has_key?(subject_id.to_i)
          exam_session_detail = exam_session_detail_map[subject_id.to_i]
          exam_session_detail.no = index
          exam_session_detail.save
          exam_session_detail_map.delete(subject_id.to_i)
        else
          ExamSessionDetail.create!(exam_session_id: self.exam_session_id, subject_id: subject_id.to_i, no: index)
        end
        index = index + 1
      end
    end
    if !exam_session_detail_map.nil? && !exam_session_detail_map.empty?
      exam_session_detail_map.each do |subject_id, exam_session_detail|
        exam_session_detail.active_flag = 0
        exam_session_detail.save
      end
    end
  end

end