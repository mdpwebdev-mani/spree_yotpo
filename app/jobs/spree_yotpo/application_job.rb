module SpreeYotpo
  class ApplicationJob < ActiveJob::Base
    around_perform do |job, block|
      block.call
    end

    private

    def ready_for_mailchimp?
      [
        mailchimp_api_key,
        mailchimp_store_id,
        mailchimp_list_id,
        mailchimp_store_name,
        cart_url
      ].map(&:nil?).none?
    end

    def mailchimp_api_key
      ::SpreeYotpo.configuration.mailchimp_api_key
    end

    def mailchimp_store_id
      ::SpreeYotpo.configuration.mailchimp_store_id
    end

    def mailchimp_list_id
      ::SpreeYotpo.configuration.mailchimp_list_id
    end

    def mailchimp_store_name
      ::SpreeYotpo.configuration.mailchimp_store_name
    end

    def cart_url
      ::SpreeYotpo.configuration.cart_url
    end

    def gibbon_store
      ::Gibbon::Request.new(api_key: mailchimp_api_key).
        ecommerce.stores(mailchimp_store_id)
    end
  end
end
