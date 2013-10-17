class AdminController < ApplicationController
  before_action :signed_in_user_admin

  def index
    @user = current_user
    #@examinations = Examination.from_users
    @examinations = Examination.paginate(page: params[:page], per_page: 10)
  end
end
