class ExportsController < ApplicationController
  def index
    column_names = ["subject_question_group_id", "subject_id", "question_group_id", "created_at", "updated_at", "active_flag"]
    list = SubjectQuestionGroup.all
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(column_names, list) }
    end
  end

  def to_csv(column_names, list)
    CSV.generate(:encoding=>"UTF-8") do |csv|
      csv << column_names
      list.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Product.create! row.to_hash
    end
  end




end
