module Subscriber

  class InvoicesController < ApplicationController

    def index
      @invoices = Invoice.
        find_all_by_stripe_customer_id(current_user.stripe_customer_id)
      render layout: "header-only"
    end

    def show
      @invoice = Invoice.new(params[:id])
      if @invoice.user == current_user
        render layout: "header-only"
      else
        not_found
      end
    rescue Stripe::InvalidRequestError
      not_found
    end

    private

    def not_found
      raise ActionController::RoutingError, "No invoice #{params[:id]}"
    end

  end

end
