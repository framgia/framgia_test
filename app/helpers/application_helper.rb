module ApplicationHelper
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Pilot App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def exam_time_s(exam_time)
    if !exam_time.nil?
      day = exam_time / (24 * 60 * 60)
      hour = exam_time / (60 * 60) % 24
      minute = (exam_time / 60) % 60
      second = exam_time % 60
      s = ''
      if day > 0
        s = s + day.to_s + ' day '
      end
      if hour > 9
        s = s + hour.to_s
      else
        s = s + '0' + hour.to_s
      end
      s = s + ':'
      if minute > 9
        s = s + minute.to_s
      else
        s = s + '0' + minute.to_s
      end
      s = s + ':'
      if second > 9
        s = s + second.to_s
      else
        s = s + '0' + second.to_s
      end
    else
      ''
    end
  end
end
