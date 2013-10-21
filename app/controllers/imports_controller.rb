class ImportsController < ApplicationController
  def index
    model_name = params[:model_name]
    if model_name.nil?
      file_names = ["Answer", "AnswerSheet", "AnswerSheetDetail", "Conclusion", "Examination", "ExamQuestion",
                    "ExamQuestionDetail", "Level", "Question", "QuestionGroup", "Subject", "SubjectQuestionGroup", "User"]
      file_names.each do |file|
        import file
      end
    else
      import(model_name)
    end
  end

  def import(file)
    CSV.foreach('db/20131021/' + file + ".csv", headers: true) do |row|
      if file == "Answer"
        Answer.create! row.to_hash
      end
      if file == "AnswerSheet"
        AnswerSheet.create! row.to_hash
      end
      if file == "AnswerSheetDetail"
        AnswerSheetDetail.create! row.to_hash
      end
      if file == "Conclusion"
        Conclusion.create! row.to_hash
      end
      if file == "Examination"
        Examination.create! row.to_hash
      end
      if file == "ExamQuestion"
        ExamQuestion.create! row.to_hash
      end
      if file == "ExamQuestionDetail"
        ExamQuestionDetail.create! row.to_hash
      end
      if file == "Level"
        Level.create! row.to_hash
      end
      if file == "Question"
        Question.create! row.to_hash
      end
      if file == "QuestionGroup"
        QuestionGroup.create! row.to_hash
      end
      if file == "Subject"
        Subject.create! row.to_hash
      end
      if file == "SubjectQuestionGroup"
        SubjectQuestionGroup.create! row.to_hash
      end
      if file == "User"
        User.create! row.to_hash
      end
    end
  end




end
