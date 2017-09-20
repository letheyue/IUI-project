Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/auth'
  end
  provider :facebook,
           APP_CONFIG['facebook']['app_id'],
           APP_CONFIG['facebook']['app_secret'],
           {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}

  provider :google_oauth2,
           APP_CONFIG['google']['app_id'],
           APP_CONFIG['google']['app_secret'],
           {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end
