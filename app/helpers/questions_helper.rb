module QuestionsHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def answer_type(answer_type)
    if answer_type == 1
      "Choice Option"
    else
      if answer_type == 2
        "Text Answer"
      else
        "Exercise"
      end
    end
  end
end
