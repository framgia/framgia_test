class LevelsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user

  def index
    @levels = Level.paginate(page: params[:page], per_page: 10, :conditions => { :active_flag => 1})
  end

  def show
    @level = Level.find(params[:id])
  end

  def new
    @level = Level.new
  end

  def create
    #binding.pry
    @level = Level.new(level_params)
    if @level.save
      flash[:success] = "Level created"
      redirect_to levels_path
    else
      render 'new'
    end
  end

  def edit
    @level = Level.find(params[:id])
  end

  def update
    @level = Level.find(params[:id])
    if @level.update_attributes(level_params)
      flash[:success] = "Level updated"
      redirect_to levels_path
    else
      render 'edit'
    end
  end

  def destroy
    Level.find(params[:id]).update_attributes(active_flag: 0)
    flash[:success] = "Level destroyed."
    redirect_to levels_path
  end

  private

  def level_params
    params.require(:level).permit(:level_name)
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
