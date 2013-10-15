class ImportsController < ApplicationController
  def index

    file_names = ["Answer", "Conclusion", "ExamQuestion", "ExamQuestionDetail", "Level",
                  "Question", "QuestionGroup", "Subject", "SubjectQuestionGroup"]
    file_names.each do |file|
      import file
    end
  end

  def import(file)
    CSV.foreach('db/' + file + ".csv", headers: true) do |row|
      if file == "Answer"
        Answer.create! row.to_hash
      end
      if file == "Conclusion"
        Conclusion.create! row.to_hash
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
    end
  end




end
