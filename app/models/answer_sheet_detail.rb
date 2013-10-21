class AnswerSheetDetail < ActiveRecord::Base
  self.table_name = 'training_answer_sheet_detail'
  self.primary_key = 'answer_sheet_detail_id'
  attr_accessor :attach_file
  default_scope -> { order('answer_sheet_detail_id') }

  before_create :default_active_values, :default_answer_correct_values
  before_update :save_file

  belongs_to :answer_sheet, class_name: "AnswerSheet"
  belongs_to :question, class_name: "Question"
  belongs_to :answer, class_name: "Answer"

  def default_active_values
    self.active_flag ||= 1
  end

  def default_answer_correct_values
    self.answer_correct ||= 0
  end

  def save_answer_correct_values
    if !self.answer.nil? && self.answer.answer_correct == 1
      self.answer_correct = 1
    end
  end

  def save_file
    uploaded_io = self.attach_file
    #binding.pry
    if !uploaded_io.nil?
      if uploaded_io.instance_of?(ActionDispatch::Http::UploadedFile)
        dir_path = "app/assets/images/answer/" + self.answer_sheet_id.to_s
        file_name = Time.now.to_i.to_s + uploaded_io.original_filename
        file_path = self.answer_sheet_id.to_s + "/" + file_name
        if !Dir.exist? Rails.root.join(dir_path)
          Dir.mkdir Rails.root.join(dir_path)
        end
        File.open(Rails.root.join(dir_path, file_name), 'wb') do |file|
          file.write(uploaded_io.read)
          self.answer_file = file_path
        end
      end
    else
      self.answer_file = nil
    end
  end

end