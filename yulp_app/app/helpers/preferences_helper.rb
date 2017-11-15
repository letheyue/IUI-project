module PreferencesHelper

  def convert_to_printable(value)
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

end