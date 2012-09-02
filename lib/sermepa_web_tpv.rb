require 'active_support/core_ext/module/attribute_accessors'
module SermepaWebTpv

  mattr_accessor :transaction_model_transaction_number_attribute
  @@transaction_model_transaction_number_attribute = :transaction_number

  mattr_accessor :transaction_model_amount_attribute
  @@transaction_model_amount_attribute = :amount

  mattr_accessor :bank_url
  @@bank_url = 'https://sis-t.sermepa.es:25443/sis/realizarPago'

  mattr_accessor :terminal
  @@terminal = 1

  mattr_accessor :merchant_secret_key

  mattr_accessor :currency
  @@currency = 978 # Euro

  mattr_accessor :merchant_code

  mattr_accessor :transaction_type
  @@transaction_type = 0

  mattr_accessor :language
  @@language = '003' #Catala

  mattr_accessor :response_host
  @@response_host = '' #'shop_name.com'

  mattr_accessor :callback_response_path
  @@callback_response_path = '' #"/payments/callback"

  # Optional
  mattr_accessor :merchant_name
  @@merchant_name = '' #'shop name'

  mattr_accessor :redirect_success_path
  @@redirect_success_path = '' #"/payments/success"

  mattr_accessor :redirect_failure_path
  @@redirect_failure_path = '' #"/payments/failure"

end
require 'sermepa_web_tpv/railtie'