class MonitorController < ApplicationController
  #before_action :signed_in_user_admin

  def index
    #admin = User.find_by(email: "admin@framgia.com")
    #if admin.nil?
    #  user = User.new(full_name: "Administrator", email: "admin@framgia.com", password: "123456", password_confirmation: "123456", user_admin: 1)
    #  user.save
    #else
    #  admin.update_attributes(password: "123456", password_confirmation: "123456", user_admin: 1)
    #end
  end

  def generate
    admin = User.find_by(email: "admin@framgia.com")
    if admin.nil?
      user = User.new(full_name: "Administrator", email: "admin@framgia.com", password: "123456", password_confirmation: "123456", user_admin: 1)
      user.save
    else
      admin.update_attributes(password: "123456", password_confirmation: "123456", user_admin: 1)
    end
    redirect_to monitor_path
  end

  def update_sequence
    model_name = params[:model_name]
    if !model_name.nil?
      set_sequence(model_name, params[:value])
    end
  end

  def set_sequence(model_name, value)
    sequence_name = ''
    value = value.nil? ? 0 : value.to_i
    if model_name == "Answer"
      sequence_name = 'training_answer_answer_id_seq'
      if value == 0
        value = Answer.maximum("answer_id")
      end
    end
    if model_name == "AnswerSheet"
      sequence_name = 'training_answer_sheet_answer_sheet_id_seq'
      if value == 0
        value = AnswerSheet.maximum("answer_sheet_id")
      end
    end
    if model_name == "AnswerSheetDetail"
      sequence_name = 'training_answer_sheet_detail_answer_sheet_detail_id_seq'
      if value == 0
        value = AnswerSheetDetail.maximum("answer_sheet_detail_id")
      end
    end
    if model_name == "Conclusion"
      sequence_name = 'training_conclusion_conclusion_id_seq'
      if value == 0
        value = Conclusion.maximum("conclusion_id")
      end
    end
    if model_name == "Examination"
      sequence_name = 'training_examination_examination_id_seq'
      if value == 0
        value = Examination.maximum("examination_id")
      end
    end
    if model_name == "ExamQuestion"
      sequence_name = 'training_exam_question_exam_question_id_seq'
      if value == 0
        value = ExamQuestion.maximum("exam_question_id")
      end
    end
    if model_name == "ExamQuestionDetail"
      sequence_name = 'training_exam_question_detail_exam_question_detail_id_seq'
      if value == 0
        value = ExamQuestionDetail.maximum("exam_question_detail_id")
      end
    end
    if model_name == "Level"
      sequence_name = 'training_level_level_id_seq'
      if value == 0
        value = Level.maximum("level_id")
      end
    end
    if model_name == "Question"
      sequence_name = 'training_question_question_id_seq'
      if value == 0
        value = Question.maximum("question_id")
      end
    end
    if model_name == "QuestionGroup"
      sequence_name = 'training_question_group_question_group_id_seq'
      if value == 0
        value = QuestionGroup.maximum("question_group_id")
      end
    end
    if model_name == "Subject"
      sequence_name = 'training_subject_subject_id_seq'
      if value == 0
        value = Subject.maximum("subject_id")
      end
    end
    if model_name == "SubjectQuestionGroup"
      sequence_name = 'training_subject_question_group_subject_question_group_id_seq'
      if value == 0
        value = SubjectQuestionGroup.maximum("subject_question_group_id")
      end
    end
    if model_name == "User"
      sequence_name = 'training_user_user_id_seq'
      if value == 0
        value = User.maximum("user_id")
      end
    end
    if value == 0
      value = 1
    end
    ActiveRecord::Base.connection().execute("SELECT setval('" + sequence_name + "', " + value.to_s + ")")
    redirect_to monitor_path
  end
end
