class ExportsController < ApplicationController
  def index
    model_name = params[:model_name]
    if model_name == "Answer"
      column_names = Answer.column_names
      list = Answer.all
    end
    if model_name == "AnswerSheet"
      column_names = AnswerSheet.column_names
      list = AnswerSheet.all
    end
    if model_name == "AnswerSheetDetail"
      column_names = AnswerSheetDetail.column_names
      list = AnswerSheetDetail.all
    end
    if model_name == "Conclusion"
      column_names = Conclusion.column_names
      list = Conclusion.all
    end
    if model_name == "ExamQuestion"
      column_names = ExamQuestion.column_names
      list = ExamQuestion.all
    end
    if model_name == "ExamQuestionDetail"
      column_names = ExamQuestionDetail.column_names
      list = ExamQuestionDetail.all
    end
    if model_name == "Examination"
      column_names = Examination.column_names
      list = Examination.all
    end
    if model_name == "Level"
      column_names = Level.column_names
      list = Level.all
    end
    if model_name == "Question"
      column_names = Question.column_names
      list = Question.all
    end
    if model_name == "QuestionGroup"
      column_names = QuestionGroup.column_names
      list = QuestionGroup.all
    end
    if model_name == "Subject"
      column_names = Subject.column_names
      list = Subject.all
    end
    if model_name == "SubjectQuestionGroup"
      column_names = SubjectQuestionGroup.column_names
      list = SubjectQuestionGroup.all
    end
    if model_name == "User"
      column_names = User.column_names
      list = User.all
    end
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(column_names, list), filename: model_name + ".csv" }
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
