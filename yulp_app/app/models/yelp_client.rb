require 'oauth2'

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
                   :params => {:location => '77840', :term => 'food'} )
    # TODO: No error handling in case of wrong input
    # This parsed JSON object has three keys, namely 'total', 'businesses', 'region'
    # Reference on the meaning of keys: https://www.yelp.com/developers/documentation/v3/business_search
    json_object.parsed
  end

  #



end