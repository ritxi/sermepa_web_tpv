require 'uri'
require 'digest/sha1'

module SermepaWebTpv
  class Request < Struct.new(:transaction, :description)
    include SermepaWebTpv::Persistence::ActiveRecord

    def bank_url
      SermepaWebTpv.bank_url
    end

    def options
      optional_options.merge(must_options)
    end

    def transact(&block)
      generate_transaction_number!
      yield(transaction)
      self
    end

    private

    def transaction_number_attribute
      SermepaWebTpv.transaction_model_transaction_number_attribute
    end

    def transaction_model_amount_attribute
      SermepaWebTpv.transaction_model_amount_attribute
    end

    def amount
      (transaction_amount * 100).to_i.to_s
    end

    def must_options
      {
        'Ds_Merchant_Amount' =>             amount,
        'Ds_Merchant_Currency' =>           SermepaWebTpv.currency, #EURO
        'Ds_Merchant_Order' =>              transaction_number,
        'Ds_Merchant_ProductDescription' => description,
        'Ds_Merchant_MerchantCode' =>       SermepaWebTpv.merchant_code,
        'Ds_Merchant_MerchantSignature' =>  signature,
        'Ds_Merchant_Terminal' =>           SermepaWebTpv.terminal,
        'Ds_Merchant_TransactionType' =>    SermepaWebTpv.transaction_type,
        'Ds_Merchant_ConsumerLanguage' =>   SermepaWebTpv.language,
        'Ds_Merchant_MerchantURL' =>        url_for(:callback_response_path)
      }
    end

    def signature
      #Ds_Merchant_Amount + Ds_Merchant_Order +Ds_Merchant_MerchantCode + Ds_Merchant_Currency +Ds_Merchant_TransactionType + Ds_Merchant_MerchantURL + CLAVE SECRETA
      merchant_code = SermepaWebTpv.merchant_code
      currency = SermepaWebTpv.currency
      transaction_type = SermepaWebTpv.transaction_type
      callback_url = url_for(:callback_response_path)
      merchant_secret_key = SermepaWebTpv.merchant_secret_key
      Digest::SHA1.hexdigest("#{amount}#{transaction_number}#{merchant_code}#{currency}#{transaction_type}#{callback_url}#{merchant_secret_key}").upcase
    end

    # Available options
    # redirect_success_path
    # redirect_failure_path
    # callback_response_path
    def url_for(option)
      host = SermepaWebTpv.response_host
      path = SermepaWebTpv.send(option)

      if host.present? && path.present?
        URI.join("http://#{host}", path).to_s
      end
    end

    def optional_options
      {
        'Ds_Merchant_Titular'      => SermepaWebTpv.merchant_name,
        'Ds_Merchant_UrlKO'        => url_for(:redirect_failure_path),
        'Ds_Merchant_UrlOK'        => url_for(:redirect_success_path)
      }.delete_if {|key, value| value.blank? }
    end


  end
end