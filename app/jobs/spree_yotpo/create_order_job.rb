# frozen_string_literal: true

module SpreeYotpo
  class CreateOrderJob < ApplicationJob
    def perform(yotpo_order)
      begin
          puts(yotpo_order.inspect)
          response = Yotpo.create_new_purchase    :app_key => yotpo_order.app_key,
                                        :utoken => yotpo_order.utoken,
                                        :email => yotpo_order.email,
                                        :customer_name => yotpo_order.customer_name,
                                        :order_id => yotpo_order.order_id,
                                        :platform => yotpo_order.platform,
                                        :order_date => yotpo_order.order_date,
                                        :products => yotpo_order.products,
                                        :currency_iso => yotpo_order.currency_iso
          raise Exception unless response.body.code == 200
      rescue Exception => e
        Rails.logger.error("[Yotpo] Error while creating order: #{e}")
      end
    end
  end
end
