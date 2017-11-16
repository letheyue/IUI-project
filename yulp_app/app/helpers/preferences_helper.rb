module PreferencesHelper

  # Helper for 3 cases of radio
  def convert_to_printable3(value)
    case value
      when 1
        'Not-Important'
      when 2
        "Don't-Mind"
      when 3
        'Important'
      else
        'Undefined'
    end
  end

  # Helper for 2 cases of radio
  def convert_to_printable2(value)
    case value
      when true
        'Yes'
      when false
        'No'
      else
        'Undefined'
    end
  end

end