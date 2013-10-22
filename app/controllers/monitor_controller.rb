class MonitorController < ApplicationController
  #before_action :signed_in_user_admin

  def index
    #admin = User.find_by(email: "admin@framgia.com")
    #if admin.nil?
    #  user = User.new(full_name: "Administrator", email: "admin@framgia.com", password: "123456", password_confirmation: "123456", user_admin: 1)
    #  user.save
    #else
    #  admin.update_attributes(password: "123456", password_confirmation: "123456", user_admin: 1)
    #end
  end

  def generate
    admin = User.find_by(email: "admin@framgia.com")
    if admin.nil?
      user = User.new(full_name: "Administrator", email: "admin@framgia.com", password: "123456", password_confirmation: "123456", user_admin: 1)
      user.save
    else
      admin.update_attributes(password: "123456", password_confirmation: "123456", user_admin: 1)
    end
    redirect_to monitor_path
  end
end
