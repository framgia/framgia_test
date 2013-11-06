class ExamQuestionsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @user = current_user
    if params[:subject_id]
      @exam_questions = ExamQuestion.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1, :subject_id => params[:subject_id]})
      @subject_id = params[:subject_id]
    else
      @exam_questions = ExamQuestion.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1})
    end
    @subjects = Subject.where(active_flag: 1)
    @levels = Level.where(active_flag: 1)
  end

  def show
    @exam_question = ExamQuestion.find(params[:id])
  end

  def new
    @exam_question = ExamQuestion.new(subject_id: params[:subject_id])
    level_ids = ExamQuestion.where("subject_id = :subject_id AND active_flag = :active_flag",
                                           subject_id: params[:subject_id].to_i, active_flag: 1).pluck(:level_id)
    if level_ids.nil? || level_ids.empty?
      @levels = Level.where("active_flag = :active_flag", active_flag: 1)
    else
      @levels = Level.where("level_id NOT IN (:level_ids) AND active_flag = :active_flag",
          level_ids: level_ids, active_flag: 1)
    end
    if @levels.nil? || @levels.empty?
      flash[:success] = "With this Subject, no more Level can be added new"
      redirect_to exam_questions_path
    end
    #@levels = Level.where(active_flag: 1)
  end

  def create
    @user = current_user
    @exam_question = ExamQuestion.new(exam_question_params)
    if check_duplicate?(nil, @exam_question.subject_id, @exam_question.level_id)
      flash[:success] = "Already exist Exam Question with this Subject and Level"
      redirect_to exam_questions_path
    end

    if @exam_question.save
      flash[:success] = "Exam Question created"
      redirect_to exam_questions_path
    else
      render 'new'
    end
  end

  def edit
    @exam_question = ExamQuestion.find(params[:id])
    @levels = Level.where(active_flag: 1)
    level_ids = ExamQuestion.where("exam_question_id <> :exam_question_id AND subject_id = :subject_id AND active_flag = :active_flag",
                                   exam_question_id: params[:id].to_i, subject_id: @exam_question.subject_id, active_flag: 1).pluck(:level_id)
    @levels = Level.where("level_id NOT IN (:level_ids) AND active_flag = :active_flag",
                          level_ids: level_ids, active_flag: 1)
    @question_groups = @exam_question.subject.question_groups
  end

  def update
    @exam_question = ExamQuestion.find(params[:id])
    if check_duplicate?(params[:id], params[:exam_question][:subject_id], params[:exam_question][:level_id])
      flash[:success] = "Already exist Exam Question with this Subject and Level"
      redirect_to exam_questions_path
      return
    end
    if @exam_question.update_attributes(exam_question_params)
      flash[:success] = "Exam Question updated"
      redirect_to exam_questions_path
    else
      render 'edit'
    end
  end

  def destroy
    ExamQuestion.find(params[:id]).update_attributes(:active_flag => 0)
    flash[:success] = "Exam Question destroyed."
    redirect_to exam_questions_path
  end

  private

  def exam_question_params
    _exam_question_params = params.require(:exam_question).permit(:subject_id, :level_id, :number_correct, :exam_time,
                                          exam_question_details_attributes: [:id, :subject_id, :question_group_id, :no, :number_question, :used])
    _exam_question_params['exam_question_details_attributes'].each do |key, exam_question_detail|
      if exam_question_detail['used'] == '0'
        _exam_question_params['exam_question_details_attributes'].delete(key)
      end
    end
    _exam_question_params
  end

  # Before filters

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.user_admin?
  end

  def check_duplicate?(exam_question_id, subject_id, level_id)
    if exam_question_id.nil?
      count = ExamQuestion.where(:subject_id => subject_id.to_i, :active_flag => 1, :level_id => level_id).count(:exam_question_id)
    else
      count = ExamQuestion.where("exam_question_id <> :exam_question_id AND subject_id = :subject_id AND level_id = :level_id AND active_flag = :active_flag", :exam_question_id => exam_question_id.to_i, :subject_id => subject_id.to_i, :active_flag => 1, :level_id => level_id.to_i).count(:exam_question_id)
    end
    #binding.pry
    if count > 0
      return true
    else
      return false
    end
  end

end
