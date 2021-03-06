module Subscriptions
  module Concerns   
    module Subscribeable
      extend ActiveSupport::Concern
  
      included do
        has_one :subscription, as: :ownerable, class_name: "Subscriptions::Subscription"
        has_many :invoices, as: :ownerable, class_name: "Subscriptions::Invoice"
      end
  
      def open_invoice
        invoices.open.first
      end
  
      def bill_outstanding_invoices!
        invoices.ready_for_payment.each(&:charge!)
        # This raises a PaymentError exception when an invoices fails to charge
      end
      
      def cancel_outstanding_invoices!
        # Only call this if you want to forgive any outstanding payments for this user
        invoices.ready_for_payment.each(&:cancelled!)
      end
    end
  end
end