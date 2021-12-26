class YotpoSetting < ActiveRecord::Base
  validates :mailchimp_api_key, :mailchimp_store_id, :mailchimp_list_id, :mailchimp_store_name, :cart_url, presence: true
  validate :validate_only_one_store, on: :create

  def validate_only_one_store
    errors.add(:base, "only one store allowed") unless YotpoSetting.count.zero?
  end

  def create_store_id
    Digest::MD5.hexdigest(mailchimp_store_name + mailchimp_list_id).to_s
  end

  def accout_name
    ::SpreeYotpo::GetAccountNameJob.perform_now(self)
  end
end
