require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Tapjoy < OmniAuth::Strategies::OAuth2
      option :name, :tapjoy

      def self.site
        if ENV['TAPJOY_AUTH_SITE']
          ENV['TAPJOY_AUTH_SITE']
        elsif ENV['TAPJOY_USE_STAGING_AUTH']
          'https://mystique-staging.herokuapp.com'
        else
          "https://oauth.tapjoy.com"
        end
      end

      def self.authorize_path
        if ENV['TAPJOY_AUTH_PATH']
          ENV['TAPJOY_AUTH_PATH'] 
        elsif  ENV['TAPJOY_USE_STAGING_AUTH']
          # Staging path is currently the same as production
          "/oauth/authorize"
        else
          "/oauth/authorize"
        end
      end

      option :client_options, {
        :site => site,
        :authorize_path => authorize_path
      }

      uid { raw_info["id"] }

      info do
        raw_info.to_hash
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end
  end
end
