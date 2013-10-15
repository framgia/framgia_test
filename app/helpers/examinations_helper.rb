module ExaminationsHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def examination_status(status)
    if status == 1
      "Testing"
    else
      if status == 2
        "Checked"
      else
        "Finished"
      end
    end
  end
end
