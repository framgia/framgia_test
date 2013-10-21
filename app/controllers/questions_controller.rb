class QuestionsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user,     only: :destroy

  def index
    if params[:subject_id]
      @questions = Question.paginate(page: params[:page], per_page: 10, :conditions => {subject_id: params[:subject_id], :active_flag => 1})
      @subject_id = params[:subject_id]
    else
      @questions = Question.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1})
    end
    @subjects = Subject.where(active_flag: 1)
  end

  def show
    @question = Question.find(params[:id])
    @subjects = Subject.where(active_flag: 1)
  end

  def new
    @subject = Subject.find(params[:subject_id])
    @question_groups = @subject.question_groups
    @question = Question.new(subject_id: params[:subject_id])
  end

  def create
    #binding.pry
    @question = Question.new(question_params)
    if @question.save
      redirect_to new_question_path + "?subject_id=" + @question.subject_id.to_s + "&question_group_id=" + @question.question_group_id.to_s + "&answer_type=" + @question.answer_type.to_s
    else
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    @subject = Subject.find(@question.subject_id)
    @question_groups = @subject.question_groups
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      flash[:success] = "Question updated"
      redirect_to edit_question_path(@question)
    else
      render 'edit'
    end
  end

  def destroy
    Question.find(params[:id]).update_attributes(active_flag: 0)
    flash[:success] = "Question destroyed."
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:subject_id, :question_group_id, :question_content,
                                 :question_file, :attach_file, :answer_type, :description, answers_attributes: [:id, :subject_id, :answer_no, :answer_content, :answer_file, :attach_file, :answer_correct])
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
