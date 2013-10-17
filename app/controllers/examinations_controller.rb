class ExaminationsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]

  def index
    @user = current_user
    @examinations = Examination.paginate(page: params[:page], per_page: 10, :conditions => { :user_id => @user.user_id})
    @subjects = Subject.where(active_flag: 1)
    @levels = Level.where(active_flag: 1)
  end

  def show
    @examination = Examination.find(params[:id])
    redirect_to examination_answer_sheet_path(@examination, @examination.first_answer_sheet)
  end

  def new
    @examination = Examination.new
  end

  def create
    @user = current_user
    @examination = Examination.new(:user_id => current_user.user_id, :status => 1)
    if @examination.save
      subject_id = params[:subject_id]
      level_id = params[:level_id]
      exam_question_ids = ExamQuestion.where("subject_id = :subject_id AND level_id = :level_id AND active_flag = :active_flag",
                                    subject_id: subject_id, level_id: level_id, active_flag: 1).pluck(:exam_question_id)
      exam_question_id = exam_question_ids.sample
      if exam_question_id
        @answer_sheet = AnswerSheet.new(:user_id => current_user.user_id, :exam_question_id => exam_question_id,
                                       :examination_id => @examination.examination_id, :subject_id => subject_id,
                                      :no => 1)
        if @answer_sheet.save
          create_answer_sheet_detail(@answer_sheet)
        end
      end
      redirect_to examination_answer_sheet_path(@examination, @answer_sheet)
    else
      render 'new'
    end
  end

  def edit
    @examination = Examination.find(params[:id])
  end

  def update
    @examination = Examination.find(params[:id])
    if @examination.update_attributes(examination_update_params)
      #flash[:success] = "Examination updated"
      #@examination.answer_sheets.each do |answer_sheet|
      #  total = 0
      #  answer_sheet.answer_sheet_details.each do |answer_sheet_detail|
      #    if answer_sheet_detail.question.answer_type == 1 && !answer_sheet_detail.answer.nil? && answer_sheet_detail.answer.answer_correct == 1
      #      total = total + 1
      #      answer_sheet_detail.update_attributes(:answer_correct => 1)
      #    end
      #  end
      #  answer_sheet.update_attributes(:exam_result => total)
      #end
      redirect_to examination_answer_sheet_path(@examination, @examination.first_answer_sheet)
    else
      render 'edit'
    end
  end

  def destroy
    Examination.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to examinations_url
  end

  private

  def examination_params
    params.require(:examination).permit(:full_name, :email, :password,
                                 :password_confirmation)
  end

  def examination_update_params
    params.require(:examination).permit(:status)
  end

  # Before filters

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def create_answer_sheet_detail(answer_sheet)
    #binding.pry
    exam_question = ExamQuestion.find(answer_sheet.exam_question_id)
    exam_question_details = exam_question.exam_question_details
    no = 1
    exam_question_details.each do |exam_question_detail|
      number_question = exam_question_detail.number_question
      i = 0
      question_ids = Question.where("subject_id = :subject_id AND question_group_id = :question_group_id AND active_flag = :active_flag",
                                    subject_id: exam_question_detail.subject_id, question_group_id: exam_question_detail.question_group_id, active_flag: 1).pluck(:question_id)
      while i < number_question && question_ids.size != 0 do
        question_id = question_ids.sample
        question_ids.delete question_id
        answer_sheet_detail = AnswerSheetDetail.new(:answer_sheet_id => answer_sheet.answer_sheet_id, :question_id => question_id, :no => no)
        if answer_sheet_detail.save
          no = no + 1
        end
        i = i + 1
      end
    end
  end

end
