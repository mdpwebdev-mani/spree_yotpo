module SpreeYotpo
    module CredentialMethods
      def credential_json
        #app_key = ::SpreeYotpo.configuration.yotpo_app_key
        #secret = ::SpreeYotpo.configuration.yotpo_secret
        #app_key = '4R76jzuyBVXUD3suesiP8Loqv1X4HrDbzzCidcUL'
        #secret = 'jXtYWPPNXSRLkdwpdOPeKH9QRwCatzyFPwCAD244'
        app_key = 'DGPvbfCS7lb9bPnog6menMUdftmQHpPfhn44hZhg'
        secret = 'IbYH6MB0g04oaQ0GSbDlfzECcm0JKudFpGMb3tfE'
        utoken = Rails.cache.fetch('yotpo_utoken', expires_in: 23.hours) do
            response = Yotpo.get_oauth_token :app_key => app_key, :secret => secret
            response.body.access_token
        end 
        {
        app_key: app_key,
        utoken: utoken,
        }.as_json
      end
  
    end
  end