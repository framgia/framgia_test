class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      @examinations = Examination.paginate(:page => params[:page], per_page: 10, :conditions => { :user_id => @user.user_id})
      redirect_to examinations_path, :page => 1
      #logger.info "---------------------------------------"
      #logger.info ExaminationDetail.all
    end

  end

  def help
  end
end
