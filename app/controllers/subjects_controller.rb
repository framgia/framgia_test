class SubjectsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @user = current_user
    @subjects = Subject.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1})
  end

  def show
    @subject = Subject.find(params[:id])
  end

  def new
    @subject = Subject.new
    @question_groups = QuestionGroup.where(active_flag: 1)
  end

  def create
    @user = current_user
    @subject = Subject.new(subject_params)
    if @subject.save
      flash[:success] = "Subject created"
      redirect_to subjects_path
    else
      render 'new'
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    @question_groups = QuestionGroup.where(active_flag: 1)
  end

  def update
    @subject = Subject.find(params[:id])
    if @subject.update_attributes(subject_params)
      flash[:success] = "Subject updated"
      redirect_to subjects_path
    else
      render 'edit'
    end
  end

  def destroy
    Subject.find(params[:id]).update_attributes(:active_flag => 0)
    @subject = Subject.find(params[:id])
    @subject.subject_question_groups.each do |subject_question_group|
      subject_question_group.update_attributes(:active_flag => 0)
    end
    flash[:success] = "Subject destroyed."
    redirect_to subjects_path
  end

  private

  def subject_params
    params.require(:subject).permit(:subject_name, :question_group_ids => [])
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
