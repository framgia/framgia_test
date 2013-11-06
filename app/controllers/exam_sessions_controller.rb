class ExamSessionsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @user = current_user
    @exam_sessions = ExamSession.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1})
  end

  def show
    @exam_session = ExamSession.find(params[:id])
  end

  def new
    @exam_session = ExamSession.new
    @levels = Level.where(active_flag: 1)
    @subjects = []
    @remain_subjects = Subject.where(active_flag: 1)
  end

  def create
    @user = current_user
    @exam_session = ExamSession.new(exam_session_params)
    if @exam_session.save
      flash[:success] = "Exam Session created"
      redirect_to exam_sessions_path
    else
      render 'new'
    end
  end

  def edit
    @exam_session = ExamSession.find(params[:id])
    @levels = Level.where(active_flag: 1)
    @subjects = []
    subject_ids = []
    if !@exam_session.exam_session_details.nil?
      @exam_session.exam_session_details.each do |exam_session_detail|
        subject_ids << exam_session_detail.subject_id
        @subjects << exam_session_detail.subject
      end
    end
    if !subject_ids.nil? && !subject_ids.empty?
      @remain_subjects = Subject.where("subject_id NOT IN (:subject_ids) AND active_flag = :active_flag", :subject_ids => subject_ids, :active_flag => 1)
    else
      @remain_subjects = Subject.where(active_flag: 1)
    end
  end

  def update
    @exam_session = ExamSession.find(params[:id])
    if @exam_session.update_attributes(exam_session_params)
      flash[:success] = "Exam Session updated"
      redirect_to exam_sessions_path
    else
      render 'edit'
    end
  end

  def destroy
    ExamSession.find(params[:id]).update_attributes(:active_flag => 0)
    flash[:success] = "Exam Session destroyed."
    redirect_to exam_sessions_path
  end

  private
  def exam_session_params
    params.require(:exam_session).permit(:level_id, :exam_session_name, :exam_date, :exam_duration, :subject_ids => [])
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

end
