class AnswersController < ApplicationController
  before_action :signed_in_user, only: [:show]

  def show
  end

end
