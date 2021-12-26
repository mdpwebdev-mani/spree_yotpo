# frozen_string_literal: true

module SpreeYotpo
  class OrderYotpoPresenter
    include CredentialMethods
    include Rails.application.routes.url_helpers

    attr_reader :order

    def initialize(order)
      @order = order
      #raise "Order in wrong state" unless order.completed?
    end

    def json
      credential_json.merge(customer).merge(products).merge(
        {
          order_id: order.number,
          platform: "general",
          order_date: order.created_at.in_time_zone("UTC").strftime("%Y-%m-%d"),
          currency_iso: order.currency || order.store&.default_currency || ::Spree::Config[:currency]
        }.as_json
      )
    end

    private


    def products

      products = order.line_items.map do |line|
        {
          "#{line.variant.sku}": {
          url: Rails.application.routes.url_helpers.collection_product_url(line.variant.product,line.product_id),
          name: line.name,
          image_url: Rails.application.routes.url_helpers.url_for(line.product.images.first.attachment.variant(resize: '150x150')),
          description: line.description,
          price: (line.price || 0).to_s
        }
      }
      end
      { products: products[0] }

    end

    def promotions
      return {} unless promotions_list.any?

      promos = promotions_list.map do |p|
        rule = PromoRuleMailchimpPresenter.new(p).json
        {
          code: p.code || "promotion:#{p.id}",
          amount_discounted: rule['amount'],
          type: rule['type']
        }
      end
      { promos: promos }
    end

    def promotions_list
      order.all_adjustments.eligible.nonzero.promotion.map(&:source).compact.map(&:promotion).uniq
    end

    def customer
        {
          customer_name: customer_full_name(),
          email: order.email || "",
        }
    end

    def customer_full_name
      first_name = order.bill_address&.firstname || ""
      last_name  = order.bill_address&.last_name || ""
      return first_name+" "+ last_name
    end

   end
end
