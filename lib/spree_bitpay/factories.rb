PAYMENT_ID = "123PAYMENTID"
ORDER_ID   = "123ORDERID"
INVOICE_ID = "123BitPayInvoiceID"

FactoryGirl.define do
  factory :bit_payment, class: Spree::PaymentMethod::BitPayment do
    name 'BPAY'
  end
  factory :bitpay_invoice, class: Spree::BitPayInvoice do
  end

  factory :abstract_btc_payment, class: Spree::Payment do
    association :payment_method, factory: :bit_payment
    association :source, factory: :bitpay_invoice
    amount { order.total }
    response_code 'BTC'
    after(:create) do |payment|
      payment.number = n_random_alpha_nums(8)
      payment.save!
      payment.order.update!
    end

    factory :invalid_payment do
      state 'invalid'
    end    
    factory :processing_bp_payment do
      state 'processing'
    end
  end
end

def n_random_alpha_nums n
  alpha_nums = (("0".."9").to_a << ("A".."Z").to_a << ("a".."z").to_a).flatten
  (0..n).to_a.reduce(""){|a, b| a << alpha_nums.sample}
end
