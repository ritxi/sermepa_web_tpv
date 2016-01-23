

module SermepaWebTpv
  BASE = Struct.new(:params) unless defined?(BASE)
  class Response < BASE
    def transaction_number
      merchant_parameters_hash['Ds_Order']
    end

    def valid?
      params['Ds_Signature'] == signature
    end

    def success?
      merchant_parameters_hash['Ds_Response'].to_i == 0
    end

    def signature
      Signature.new(self).signature.gsub!(/[+\/]/, '+' => '-', '/' => '_')
    end

    def merchant_parameters
      params['Ds_MerchantParameters']
    end

    def merchant_paramters_json
      @merchant_paramters_json ||=
        Base64.urlsafe_decode64(merchant_parameters)
    end

    def merchant_parameters_hash
      @merchant_parameters_hash ||=
        JSON.parse(merchant_paramters_json)
    end
  end
end
