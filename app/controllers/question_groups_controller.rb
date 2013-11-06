class QuestionGroupsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @question_groups = QuestionGroup.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1})
  end

  def show
    @question_group = QuestionGroup.find(params[:id])
  end

  def new
    @question_group = QuestionGroup.new
  end

  def create
    #binding.pry
    @question_group = QuestionGroup.new(question_group_params)
    if @question_group.save
      flash[:success] = "Level created"
      redirect_to question_groups_path
    else
      render 'new'
    end
  end

  def edit
    @question_group = QuestionGroup.find(params[:id])
  end

  def update
    @question_group = QuestionGroup.find(params[:id])
    if @question_group.update_attributes(question_group_params)
      flash[:success] = "Question Group updated"
      redirect_to question_groups_path
    else
      render 'edit'
    end
  end

  def destroy
    QuestionGroup.find(params[:id]).update_attributes(active_flag: 0)
    flash[:success] = "Question Group destroyed."
    redirect_to question_groups_path
  end

  private

  def question_group_params
    params.require(:question_group).permit(:question_group_name)
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
