
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
                   :params => {:location => '77840', :term => 'food', :limit => 50} )
    # TODO: No error handling in case of wrong input
    # This parsed JSON object has three keys, namely 'total', 'businesses', 'region'
    # Reference on the meaning of keys: https://www.yelp.com/developers/documentation/v3/business_search
    # byebug
    result = json_object.parsed
    total_businesses = result['total']
    cur_offset = 50
    while cur_offset < total_businesses
      new_json_object = client.request(:get, 'v3/businesses/search',
                                       :headers => {Authorization: "Bearer #{token_from_yelp.token}"},
                                       :params =>
                                           {:location => '77840', :term => 'restaurant', :offset => cur_offset, :limit => 50})
      result['businesses'] = result['businesses'] + new_json_object.parsed['businesses']
      cur_offset += 50
      # byebug
    end
    result
  end

  # This method implements as the wrapper of Reviews API
  def self.review(id)
    token_from_yelp = generate_token
    url = 'v3/businesses/' + id + '/reviews'
    # transfer the name_id to ascii
    uri = ERB::Util.url_encode(url)
    #uri = Addressable::URI.parse(url)
    json_object = client.request(:get, uri, :headers => {Authorization: "Bearer #{token_from_yelp.token}"})
    json_object.parsed
  rescue Exception => ex
    logger.fatal(ex)
    return {}
  end

  def self.business(id)
    token_from_yelp = generate_token
    url = 'v3/businesses/' + id
    uri = ERB::Util.url_encode(url)
    #uri = Addressable::URI.parse(url)
    json_object = client.request(:get, uri, :headers => {Authorization: "Bearer #{token_from_yelp.token}"})
    json_object.parsed
  rescue Exception => ex
    logger.fatal(ex)
    return {}
  end


end