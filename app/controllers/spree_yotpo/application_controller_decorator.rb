module SpreeYotpo
  module ApplicationControllerDecorator
    def self.prepended(base)
      base.before_action :set_campaign_id

      base.helper SpreeYotpo::Engine.helpers
    end

    private

    def set_campaign_id
      return if params["mc_cid"].nil?

      cookies[:mailchimp_campaign_id] = {
        value: params["mc_cid"]
      }
    end

    def mailchimp_store_id
      @store_id = ::SpreeYotpo.configuration.mailchimp_store_id
    end
  end
end
ApplicationController.prepend(SpreeYotpo::ApplicationControllerDecorator)
