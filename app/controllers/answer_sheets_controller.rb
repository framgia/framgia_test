class AnswerSheetsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]

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
  end

  def update
    @answer_sheet = AnswerSheet.find(params[:id])
    if @answer_sheet.update_attributes(answer_sheet_params)
      total = 0
      @answer_sheet.answer_sheet_details.each do |answer_sheet_detail|
        if answer_sheet_detail.answer_correct == 1
          total = total + 1
        end
      end
      @answer_sheet.update_attributes(:exam_result => total)
      flash[:success] = "Answer sheet updated"
      if admin_user?
        redirect_to admin_url
      else
        redirect_to root_url
      end
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

end
