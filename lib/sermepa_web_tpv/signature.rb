require 'base64'
require 'openssl'
require 'mcrypt'

module SermepaWebTpv
  class Signature
    include SermepaWebTpv::Persistence::ActiveRecord

    attr_reader :action

    class << self
      def iv
        # "\x00\x00\x00\x00\x00\x00\x00\x00"
        0.chr * 8
      end

      def merchant_key
        Base64.decode64(SermepaWebTpv.merchant_secret_key)
      end

      def cipher
        Mcrypt.new(:tripledes, :cbc, merchant_key, iv, :zeros)
      end

      def digestor
        @digestor ||= OpenSSL::Digest.new('sha256')
      end
    end

    def initialize(action)
      @action = action
    end

    def signature
      Base64.encode64(
        OpenSSL::HMAC.digest(self.class.digestor, key,
                             action.merchant_parameters))
        .strip
    end

    def key
      self.class.cipher.encrypt(action.transaction_number)
    end
  end
end
