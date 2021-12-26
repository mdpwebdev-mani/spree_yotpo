require 'spree_core'
require 'spree_extension'
require 'spree_yotpo/engine'
require 'spree_yotpo/version'
require "yotpo"

module SpreeYotpo
    class << self
      def configuration
        Configuration.new
      end
    end
  
    class Configuration
      ATTR_LIST = [:yotpo_app_key, :yotpo_secret, :yotpo_store]
  
      ATTR_LIST.each do |a|
        define_method a do
          setting_model.try(a)
        end
      end
  
      private
  
      def setting_model
        ::YotpoSetting.last
      end
    end
  end
  