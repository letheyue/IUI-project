
require 'oauth2'
require 'net/http'
require "erb"

class YelpClient < ApplicationRecord

  def self.client
    client_id =     APP_CONFIG['yelp']['client_id']
    client_secret = APP_CONFIG['yelp']['secret']
    endpoint =      APP_CONFIG['yelp']['endpoint']
    token_url =     APP_CONFIG['yelp']['token_url']

    @client ||= OAuth2::Client.new(client_id, client_secret, :site => endpoint, :token_url => token_url)
  end

  def self.generate_token
    @token = client.client_credentials.get_token unless @token.present? && !@token.expired?
    @token
  end

  # This method implements as the wrapper of search API
  def self.search(filter_hash)
    token_from_yelp = generate_token
    json_object = client.request(:get, 'v3/businesses/search', :headers => {Authorization: "Bearer #{token_from_yelp.token}"},
                   :params => {:location => '77840', :term => 'food', :limit => 3} )
    # TODO: No error handling in case of wrong input
    # This parsed JSON object has three keys, namely 'total', 'businesses', 'region'
    # Reference on the meaning of keys: https://www.yelp.com/developers/documentation/v3/business_search
    json_object.parsed

  end

  # This method implements as the wrapper of Reviews API
  def self.review(id)
    token_from_yelp = generate_token
    url = 'v3/businesses/' + id + '/reviews'
    uri = ERB::Util.url_encode(url)
    #uri = Addressable::URI.parse(url)
    json_object = client.request(:get, uri, :headers => {Authorization: "Bearer #{token_from_yelp.token}"})
    json_object.parsed
  end

  def self.business(filter_hash)
    whole_json = YelpClient.search({})
    token_from_yelp = generate_token
    index = 0
    hash = Hash.new

    whole_json["businesses"].each do |element|
      id = element["id"]
      uri = 'https://api.yelp.com/v3/businesses/' + id

      json_object = client.request(:get, uri, :headers => {Authorization: "Bearer #{token_from_yelp.token}"})
      json = json_object.parsed

      hours = json["hours"]
      week_hour = Hash.new
      hours["open"].each do |d|
        start_end_hour = Hash.new
        start_end_hour["start"] = d["start"]
        start_end_hour["end"] = d["end"]
        week_hour[d["day"]] = start_end_hour
      end

      hash["" + index] = week_hour
      index = index + 1
    end

    hash
  end


end