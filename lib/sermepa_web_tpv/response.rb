require 'digest/sha1'

module SermepaWebTpv
  class Response < Struct.new(:params)
    def valid?
      params[:Ds_Signature] == signature
    end

    def success?
      params[:Ds_Response].to_i == 0
    end

    private
    def signature
      response = %W(
        #{params[:Ds_Amount]}
        #{params[:Ds_Order]}
        #{params[:Ds_MerchantCode]}
        #{params[:Ds_Currency]}
        #{params[:Ds_Response]}
        #{SermepaWebTpv.merchant_secret_key}
      ).join
      Digest::SHA1.hexdigest(response).upcase
  end
end