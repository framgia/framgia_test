class AnswerSheetDetailsController < ApplicationController
  before_action :signed_in_user, only: [:show]

  def show
    if params[:attachment] == 'attachment'
      answer_sheet_detail = AnswerSheetDetail.find params[:id]
      send_file "app/assets/images/answer/" + answer_sheet_detail.answer_file, :x_sendfile => true, :disposition => 'attachment'
    end
  end

end
