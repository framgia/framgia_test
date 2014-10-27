class AnswerSheetsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:index, :show, :edit, :update, :destroy]

  def index
    @answer_sheet = AnswerSheet.paginate(page: params[:page])
  end

  def show
    @examination = Examination.find(params[:examination_id])
    @answer_sheet = AnswerSheet.find(params[:id])
  end

  def new
    @answer_sheet = AnswerSheet.new
  end

  def create
    @examination = Examination.new(examination_params)
    if @examination.save
      redirect_to @examination
    else
      render 'new'
    end
  end

  def edit
    @examination = Examination.find(params[:examination_id])
    @answer_sheet = AnswerSheet.find(params[:id])
    if @answer_sheet.started_at.nil?
      @answer_sheet.update_attributes(started_at: Time.now)
      @answer_sheet = AnswerSheet.find(params[:id])
    end
    redirect_to [@examination, @answer_sheet]
  end

  def update
    @examination = Examination.find(params[:examination_id])
    @answer_sheet = AnswerSheet.find(params[:id])
    if @answer_sheet.update_attributes(answer_sheet_params)
      total = 0
      @answer_sheet.answer_sheet_details.each do |answer_sheet_detail|
        if answer_sheet_detail.answer_correct == 1
          total = total + 1
        end
      end
      if @examination.status == 1
        exam_time = Time.now.to_i - @answer_sheet.started_at.to_i
        @answer_sheet.update_attributes(:exam_result => total, :exam_time => exam_time)
      else 
        @answer_sheet.update_attributes(:exam_result => total)
      end
      flash[:success] = "Answer sheet updated"
      redirect_to [@examination, @answer_sheet]
      #binding.pry
      #next_answer_sheet = @examination.next_answer_sheet(@answer_sheet)
      #if !next_answer_sheet.nil?
      #  redirect_to examination_answer_sheet_path(@examination, next_answer_sheet)
      #else
      #  if admin_user?
      #    redirect_to admin_url
      #  else
      #    redirect_to root_url
      #  end
      #end
    else
      render 'show'
    end
  end

  def destroy
    Examination.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to examinations_url
  end

  private
  def answer_sheet_params
    params.require(:answer_sheet).permit(answer_sheet_details_attributes: [:id, :answer_id, :answer_content, :answer_file, :attach_file, :answer_correct])
  end

  # Before filters

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    examination = Examination.find(params[:examination_id])
    if !current_user.user_admin? && !current_user?(examination.user)
      flash[:success] = "You can not show the examination of another"
      redirect_to(root_url)
    end
  end

end
