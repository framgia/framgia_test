class Answer < ActiveRecord::Base
  self.table_name = 'training_answer'
  self.primary_key = 'answer_id'
  attr_accessor :attach_file, :subject_id
  default_scope -> { order('answer_no') }
  before_create :default_active_values, :save_file
  before_update :save_file

  belongs_to :question, class_name: "Question"

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
          self.answer_file = file_path
        end
      end
    else
      if self.answer_file == 'change'
        self.answer_file = nil
      end
    end
  end
end