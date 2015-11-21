require 'uri'

module SermepaWebTpv
  class Request < Struct.new(:transaction, :description)
    include SermepaWebTpv::Persistence::ActiveRecord

    def bank_url
      SermepaWebTpv.bank_url
    end

    def transact(&block)
      generate_transaction_number!
      yield(transaction)
      transaction
    end

    def options
      optional_options.merge(must_options)
    end

    def merchant_parameters_json
      options.to_json
    end

    def merchant_parameters
      Base64.urlsafe_encode64(
        merchant_parameters_json).split("\n").join('')
    end

    def params
      {
        'Ds_SignatureVersion' => 'HMAC_SHA256_V1',
        'Ds_MerchantParameters' => merchant_parameters,
        'Ds_Signature' => signature
      }
    end
    private

    def signature
      @signature ||= Signature.new(self).signature
    end

    def must_options
      {
        'Ds_Merchant_Amount' =>             amount,
        'Ds_Merchant_Order' =>              transaction_number,
        'Ds_Merchant_ProductDescription' => description,
        'Ds_Merchant_Currency' =>           SermepaWebTpv.currency,
        'Ds_Merchant_MerchantCode' =>       SermepaWebTpv.merchant_code,
        'Ds_Merchant_Terminal' =>           SermepaWebTpv.terminal,
        'Ds_Merchant_TransactionType' =>    SermepaWebTpv.transaction_type,
        'Ds_Merchant_ConsumerLanguage' =>   SermepaWebTpv.language,
        'Ds_Merchant_MerchantURL' =>        url_for(:callback_response_path)
      }
    end

    # Available options
    # redirect_success_path
    # redirect_failure_path
    # callback_response_path
    def url_for(option)
      host = SermepaWebTpv.response_host
      path = SermepaWebTpv.send(option)

      return if !host.present? || !path.present?
      URI.join(host, path).to_s
    end

    def optional_options
      {
        'Ds_Merchant_Titular'      => SermepaWebTpv.merchant_name,
        'Ds_Merchant_UrlKO'        => url_for(:redirect_failure_path),
        'Ds_Merchant_UrlOK'        => url_for(:redirect_success_path),
        'Ds_Merchant_PayMethods'   => SermepaWebTpv.pay_methods
      }.delete_if { |_key, value| value.blank? }
    end

    def transaction_number_attribute
      SermepaWebTpv.transaction_model_transaction_number_attribute
    end

    def transaction_model_amount_attribute
      SermepaWebTpv.transaction_model_amount_attribute
    end

    def amount
      (transaction_amount * 100).to_i.to_s
    end
  end
end