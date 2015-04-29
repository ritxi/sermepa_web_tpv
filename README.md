# Sermepa web TPV

Add simple web payment tpv to your rails application

Example app source at: https://github.com/ritxi/sermepa_web_tpv_sample_app

Steps to use it:

1. Create a new rails application

	rails new payment_app

2. Add sermepa_web_tpv to your Gemfile

	gem 'sermepa_web_tpv'

3. Add a transaction model with an amount and transaction_number fields

	rails g model Transaction amount:float transaction_number:integer

4. Configure tpv options

```ruby
module MyApp
  class Application < Rails::Application
    config.web_tpv.bank_url = 'https://sis-t.sermepa.es:25443/sis/realizarPago'
    config.web_tpv.response_host = 'my_application_host.com'
    config.web_tpv.merchant_code = '000000000'
    config.web_tpv.terminal = 1
    config.web_tpv.callback_response_path = '/payments/validate'
    config.web_tpv.redirect_success_path = '/payments/success'
    config.web_tpv.redirect_failure_path = '/payments/failure'
    config.web_tpv.merchant_secret_key = 'superseeeecretstring'
    config.web_tpv.currency = 978 # Euro

    config.web_tpv.transaction_type = 0
    config.web_tpv.language = '003' #Catala
    config.web_tpv.merchant_name = 'MY MERCHANT NAME'
    config.web_tpv.pay_methods = 'C' # Only credit card
  end
end
```

5. Add a controller payment to perform a new request payment and receive payment result

```ruby
MyApp::Application.routes.draw do
  get 'payments/new' => 'payments#new', :as => 'new_payment'
  post 'payments/validate' => 'payments#validate', :as => 'payment_validate'
  get  'payments/success' => 'payments#success', :as => 'payment_success'
  get  'payments/failure' => 'payments#failure', :as => 'payment_failure'
end
```

```ruby
class PaymentsController
  skip_before_filter :verify_authenticity_token

  def new
    transaction = Transaction.new(amount: 10)
    request = SermepaWebTpv::Request.new(transaction, "Transaction description")
    request.transact {|t| t.save }
    render json: { options: sermepa_request.options, url: sermepa_request.bank_url }
    # Submit a form with given options to the url
  end

  def success
    flash[:notice] = "Payment done successfuly!"
    redirect_to root_path
  end

  def failure
    flash[:failure] = "Payment failed, try again later."
    redirect_to root_path
  end

  def validate
    response = SermepaWebTpv::Response.new(params)
    if response.valid? && response.success?
      # mark your transaction as finished
    end
  end
end
```

