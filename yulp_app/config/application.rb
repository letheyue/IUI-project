require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YulpApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # These lines cannot be push into Heroku
    # https://github.com/rails/sprockets-rails/issues/237
    config.assets.precompile << Proc.new do |path|
      if path =~ /\.(css|js)\z/
        full_path = Rails.application.assets.resolve(path).to_s
        app_assets_path = Rails.root.join('app', 'assets').to_s
        if full_path.starts_with? app_assets_path
          true
        else
          false
        end
      else
        false
      end
    end

  end
end
