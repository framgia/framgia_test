class Subject < ActiveRecord::Base
  self.table_name = 'training_subject'
  self.primary_key = 'subject_id'
  attr_accessor :question_group_ids
  default_scope -> { order('subject_id') }

  before_create :default_active_values
  after_save :save_subject_question_group

  has_many :subject_question_groups, foreign_key: "subject_id", class_name: "SubjectQuestionGroup", :conditions => "training_subject_question_group.active_flag = 1"
  has_many :question_groups, through: :subject_question_groups, source: :question_group, class_name: "QuestionGroup"

  def default_active_values
    self.active_flag ||= 1
  end

  def save_subject_question_group
    #binding.pry
    if !self.question_group_ids.nil? && !self.question_group_ids.empty?
      self.question_group_ids.each do |question_group_id|
        if !question_group_id.nil? && !question_group_id.empty?
          count = SubjectQuestionGroup.where(subject_id: self.subject_id, question_group_id: question_group_id, active_flag: 1).count(:subject_question_group_id)
          if count <= 0
            SubjectQuestionGroup.create!(subject_id: self.subject_id, question_group_id: question_group_id)
          end
        end
        #binding.pry
      end
      subject_question_groups = SubjectQuestionGroup.where("question_group_id NOT IN (:question_group_ids) AND active_flag = :active_flag", question_group_ids: self.question_group_ids, active_flag: 1)
      if !subject_question_groups.nil? && !subject_question_groups.empty?
        subject_question_groups.each do |subject_question_group|
          subject_question_group.update_attributes(:active_flag => 0)
        end
      end
    end
  end

  def current_question_group_ids
    current_question_group_ids = []
    if !self.question_groups.nil? && !self.question_groups.empty?
      self.question_groups.each do |question_group|
        current_question_group_ids << question_group.question_group_id
      end
    end
    #binding.pry
    current_question_group_ids
  end

end