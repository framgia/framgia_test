class AdminController < ApplicationController
  def index
    @user = current_user
    @examinations = Examination.from_users
  end
end
