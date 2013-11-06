class Question < ActiveRecord::Base
  self.table_name = 'training_question'
  self.primary_key = 'question_id'
  attr_accessor :attach_file
  default_scope -> { order('question_id') }
  before_create :default_active_values, :save_file
  before_update :save_file

  has_many :answers, foreign_key: "question_id", class_name:  "Answer", dependent: :destroy, :conditions => "training_answer.active_flag = 1"
  belongs_to :subject, class_name: "Subject"
  belongs_to :question_group, class_name: "QuestionGroup"
  accepts_nested_attributes_for :answers

  def default_active_values
    self.active_flag ||= 1
  end

  def save_file
    uploaded_io = self.attach_file
    #binding.pry
    if !uploaded_io.nil?
      if uploaded_io.instance_of?(ActionDispatch::Http::UploadedFile)
        dir_path = "app/assets/images/question/" + self.subject_id.to_s
        file_name = Time.now.to_i.to_s + uploaded_io.original_filename
        file_path = self.subject_id.to_s + "/" + file_name
        if !Dir.exist? Rails.root.join(dir_path)
          Dir.mkdir Rails.root.join(dir_path)
        end
        File.open(Rails.root.join(dir_path, file_name), 'wb') do |file|
          file.write(uploaded_io.read)
          self.question_file = file_path
        end
      end
    else
      if self.question_file == 'change'
        self.question_file = nil
      end
    end
  end

end