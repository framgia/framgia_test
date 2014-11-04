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
    redirect_to monitor_path
  end

  def import(file)
    CSV.foreach('db/20140630' + file + ".csv", headers: true) do |row|
      if file == "Answer"
        #Answer.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(Answer, row.to_hash))
      end
      if file == "AnswerSheet"
        #AnswerSheet.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(AnswerSheet, row.to_hash))
      end
      if file == "AnswerSheetDetail"
        #AnswerSheetDetail.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(AnswerSheetDetail, row.to_hash))
      end
      if file == "Conclusion"
        #Conclusion.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(Conclusion, row.to_hash))
      end
      if file == "Examination"
        #Examination.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(Examination, row.to_hash))
      end
      if file == "ExamQuestion"
        #ExamQuestion.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(ExamQuestion, row.to_hash))
      end
      if file == "ExamQuestionDetail"
        #ExamQuestionDetail.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(ExamQuestionDetail, row.to_hash))
      end
      if file == "Level"
        #Level.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(Level, row.to_hash))
      end
      if file == "Question"
        #Question.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(Question, row.to_hash))
      end
      if file == "QuestionGroup"
        #QuestionGroup.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(QuestionGroup, row.to_hash))
      end
      if file == "Subject"
        #Subject.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(Subject, row.to_hash))
      end
      if file == "SubjectQuestionGroup"
        #SubjectQuestionGroup.create! row.to_hash
        ActiveRecord::Base.connection().execute(make_sql(SubjectQuestionGroup, row.to_hash))
      end
      if file == "User"
        ActiveRecord::Base.connection().execute(make_sql(User, row.to_hash))
        #User.create! row.to_hash
      end
    end
  end

  def make_sql(model, row_hash)
    row_hash.each do |k,v|
      if !row_hash[k].nil?
        row_hash[k] = ActiveRecord::Base.connection.quote(row_hash[k])
      else
        row_hash[k] = "null"
      end
    end
    "INSERT INTO " + model.table_name + "(" + row_hash.keys.join(",") + ") VALUES (" + row_hash.values.join(",") + ")"
  end

  def model_column_names
  {
    "Answer" => ["answer_id", "question_id", "answer_no", "answer_content", "answer_file", "answer_correct", "created_at", "updated_at", "active_flag"],
    "AnswerSheet" => ["answer_sheet_id", "user_id", "exam_question_id", "examination_id", "subject_id", "no", "exam_result", "exam_time", "started_at", "created_at", "updated_at", "active_flag"],
    "AnswerSheetDetail" => ["answer_sheet_detail_id", "answer_sheet_id", "question_id", "answer_id", "no", "answer_content", "answer_file", "answer_correct", "created_at", "updated_at", "active_flag"],
    "Conclusion" => ["conclusion_id", "conclusion_name", "created_at", "updated_at", "active_flag"],
    "Examination" => ["examination_id", "user_id", "conclusion_id", "status", "created_at", "updated_at", "active_flag"],
    "ExamQuestion" => ["exam_question_id", "subject_id", "level_id", "number_correct", "exam_time", "created_at", "updated_at", "active_flag"],
    "ExamQuestionDetail" => ["exam_question_detail_id", "exam_question_id", "subject_id", "question_group_id", "number_question", "no", "created_at", "updated_at", "active_flag"],
    "Level" => ["level_id", "level_name", "created_at", "updated_at", "active_flag"],
    "Question" => ["question_id", "subject_id", "question_group_id", "question_content", "question_file", "answer_type", "description", "created_at", "updated_at", "active_flag"],
    "QuestionGroup" => ["question_group_id", "question_group_name", "created_at", "updated_at", "active_flag"],
    "Subject" => ["subject_id", "subject_name", "created_at", "updated_at", "active_flag"],
    "SubjectQuestionGroup" => ["subject_question_group_id", "subject_id", "question_group_id", "created_at", "updated_at", "active_flag"],
    "User" => ["user_id", "full_name", "email", "password_digest", "remember_token", "user_admin", "created_at", "updated_at", "active_flag"]
  }
  end


end
