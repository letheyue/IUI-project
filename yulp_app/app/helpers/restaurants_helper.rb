module RestaurantsHelper

  def get_popular_time(restaurant)
    eval(restaurant[:popular_times])[convert_day(Time.now.wday)]
  end

  def convert_day(day_num)
    case day_num
      when 0
        'Sunday'
      when 1
        'Monday'
      when 2
        'Tuesday'
      when 3
        'Wednesday'
      when 4
        'Thursday'
      when 5
        'Friday'
      when 6
        'Saturday'
      else
        'Noday'
    end
  end


end
