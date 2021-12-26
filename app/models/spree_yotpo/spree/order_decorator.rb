module SpreeYotpo
  module Spree
    module OrderDecorator
      def self.prepended(base)
        #base.before_update :create_yotpo_cart, if: proc { email_changed? }
        base.state_machine.after_transition to: :complete, do: :after_ship_yotpo_jobs
        #base.state_machine.after_transition to: :canceled, do: :after_cancel_jobs
      end

      def associate_user!(user, override_email = true)
        super
        create_yotpo_cart unless new_record? || line_items.empty?
        true
      end

   
      def yotpo_order
        ::SpreeYotpo::OrderYotpoPresenter.new(self).json
      end

     # def update_yotpo_cart
     #   return unless yotpo_cart_created

     #   ::SpreeYotpo::UpdateOrderCartJob.perform_later(yotpo_cart)
     # end


      def after_ship_yotpo_jobs
        create_yotpo_order
      end

      def after_refund_jobs
        #update_yotpo_order
      end

      private

      def after_cancel_jobs
        #update_yotpo_order
      end
   
      def create_yotpo_order
        ::SpreeYotpo::CreateOrderJob.perform_later(yotpo_order)
      end
    end
  end
end
Spree::Order.prepend(SpreeYotpo::Spree::OrderDecorator)
