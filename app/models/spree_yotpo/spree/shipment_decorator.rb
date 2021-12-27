module SpreeYotpo
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.state_machine.after_transition to: :shipped, do: :add_yotpo_ship_notification, if: :order_shipped?
      end

      private

      def add_yotpo_ship_notification
        order.after_ship_yotpo_jobs
      end

      def order_shipped?
        order.shipment_state == "shipped"
      end
    end
  end
end
Spree::Shipment.prepend(SpreeYotpo::Spree::ShipmentDecorator)
