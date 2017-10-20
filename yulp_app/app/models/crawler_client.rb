require 'open-uri'
require 'nokogiri'
require 'watir'

class CrawlerClient


  def self.get_all_discount_info(name_location_hash)
    result = {}

    random = Random.new(1234)
    name_location_hash.each do |name, _|
      random_number = random.rand(100)
      if random_number < 60
        discount = 0
      elsif random_number < 85
        discount = 10
      elsif random_number < 95
        discount = 20
      else
        discount = 40
      end
      result[name] = discount
    end
    result
  end

  # Document for this method:
  # Input: name-location Hash
  # Output: day-popularTimes Hash
  # Example Input / Output:
  # "Centro American Restaurant Pupuseria & Pupuseria" -> "317 Dominik Dr"
  # {"Monday"=>     [0, 0, 0, 0, 13, 23, 36, 44, 40, 35, 32, 38, 45, 47, 40, 26, 0, 0],
  #  "Tuesday"=>    [0, 0, 0, 0, 16, 31, 45, 56, 55, 45, 36, 35, 42, 44, 31, 14, 0, 0],
  #  "Wednesday"=>  [0, 0, 0, 0, 18, 27, 34, 38, 34, 27, 19, 25, 48, 65, 47, 18, 0, 0],
  #  "Thursday"=>   [0, 0, 0, 0, 16, 29, 44, 51, 45, 35, 26, 27, 44, 53, 44, 23, 0, 0],
  #  "Friday"=>     [0, 0, 0, 0, 13, 26, 38, 45, 47, 44, 35, 29, 45, 75, 60, 20, 0, 0],
  #  "Saturday"=>   [0, 0, 0, 0, 7, 20, 36, 47, 47, 40, 36, 31, 27, 26, 26, 20, 0, 0],
  #  "Sunday"=>     []}

  # def self.get_popular_times(name, location)
  #   prefix = 'https://www.google.com/search?&q='
  #   query_terms = parse_whitespace(name) + parse_whitespace(location)
  #   query_parsed = ''
  #
  #   query_terms.each do |term|
  #     query_parsed += term
  #     query_parsed += '+'
  #   end
  #
  #   search_url = prefix + query_parsed
  #
  #   # open_uri will not work since it requires Javascript to be fully loaded
  #   # doc = Nokogiri::HTML(open(search_url), nil, Encoding::UTF_8.to_s)
  #   # doc = Nokogiri::HTML(open(search_url))
  #   # Instead, a browser might work
  #   browser = Watir::Browser.new :chrome
  #   browser.window.move_to(3000, 2000)
  #   browser.goto search_url
  #   sleep(3)
  #
  #   doc = Nokogiri::HTML.parse(browser.html)
  #   browser.close if browser
  #
  #   popular_times = filter_popular_times(doc)
  #   popular_times
  # end

  def self.get_all_popular_times(name_location_hash)
    result = {}

    prefix = 'https://www.google.com/search?&q='
    browser = Watir::Browser.new :chrome
    # browser.window.move_to(3000, 2000)

    name_location_hash.each do |name, location|
      query_terms = parse_whitespace(name) + parse_whitespace(location)
      query_parsed = ''
      query_terms.each do |term|
        query_parsed += term
        query_parsed += '+'
      end
      search_url = prefix + query_parsed
      browser.goto search_url
      sleep(3)
      doc = Nokogiri::HTML.parse(browser.html)
      # browser.close if browser

      popular_times = filter_popular_times(doc)
      result[name] = popular_times
    end
    browser.close if browser
    result
  end

  def self.filter_popular_times(html)
    result = {}
    # byebug
    if html.at_css('div[aria-hidden=false]').nil?
      return result
    else
      popular_times_block = html.at_css('div[aria-hidden=false]').parent
    end

    popular_times_block.children.each_with_index do |daily_time_block, index|
      if daily_time_block.attributes["aria-hidden"].value == 'true'
        daily_bar_graph_block = daily_time_block.children[1]
      else
        daily_bar_graph_block = daily_time_block.children[2]
      end
      daily_bars = []

      if daily_bar_graph_block.nil?
        result[convert_to_days(index)] = daily_bars
      else
        daily_bar_graph_block.children.each do |bar|
          height = bar.attributes['style']
          daily_bars << if height
                          height.value[/#{"height:"}(.*?)#{"px"}/m, 1].to_i
                        else
                          0
                        end
        end
        result[convert_to_days(index)] = daily_bars
      end
    end
    result
  end

  def self.parse_whitespace(str)
    return Array.new if str.nil?
    str.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(' ')
  end


  def self.convert_to_days(index)
    case index
    when 0
      'Monday'
    when 1
      'Tuesday'
    when 2
      'Wednesday'
    when 3
      'Thursday'
    when 4
      'Friday'
    when 5
      'Saturday'
    when 6
      'Sunday'
    else
      'Undefined'
    end
  end
end
