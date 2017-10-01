require 'open-uri'
require 'nokogiri'
require 'watir'

class GoogleClient
  def self.get_all_popular_times(name_location_hash)
    result = {}

    prefix = 'https://www.google.com/search?&q='
    browser = Watir::Browser.new :chrome
    browser.window.move_to(3000, 2000)


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

  def self.get_popular_times(name, location)
    prefix = 'https://www.google.com/search?&q='
    query_terms = parse_whitespace(name) + parse_whitespace(location)
    query_parsed = ''

    query_terms.each do |term|
      query_parsed += term
      query_parsed += '+'
    end

    search_url = prefix + query_parsed

    # open_uri will not work since it requires Javascript to be fully loaded
    # doc = Nokogiri::HTML(open(search_url), nil, Encoding::UTF_8.to_s)
    # doc = Nokogiri::HTML(open(search_url))
    # Instead, a browser might work
    browser = Watir::Browser.new :chrome
    browser.window.move_to(3000, 2000)
    browser.goto search_url
    sleep(3)

    doc = Nokogiri::HTML.parse(browser.html)
    browser.close if browser

    popular_times = filter_popular_times(doc)
    popular_times
  end

  def self.filter_popular_times(html)
    result = {}
    # byebug
    popular_times_block = html.at_css('div[aria-hidden=false]').parent
    popular_times_block.children.each_with_index do |daily_time_block, index|
      daily_bar_graph_block = daily_time_block.children[2]
      daily_bars = []
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
    result
  end

  def self.parse_whitespace(str)
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
