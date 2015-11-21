require 'spec_helper'

describe SermepaWebTpv::Signature do
  let(:params) do
    Base64.encode64(
      '{"DS_MERCHANT_AMOUNT":"145",' \
      '"DS_MERCHANT_ORDER":"1442772645",' \
      '"DS_MERCHANT_MERCHANTCODE":"999008881",' \
      '"DS_MERCHANT_CURRENCY":"978",' \
      '"DS_MERCHANT_TRANSACTIONTYPE":"0",' \
      '"DS_MERCHANT_TERMINAL":"871",' \
      '"DS_MERCHANT_MERCHANTURL":"https://ejemplo/ejemplo_URL_Notif.php",' \
      '"DS_MERCHANT_URLOK":"https://ejemplo/ejemplo_URL_OK_KO.php",' \
      '"DS_MERCHANT_URLKO":"https://ejemplo/ejemplo_URL_OK_KO.php"}')
      .split("\n").join('')
  end

  let(:transaction_number) { '1442772645' }
  let(:action) do
    double(transaction_number: transaction_number,
           merchant_parameters: params)
  end
  let(:signator) { described_class.new(action) }

  describe '#signature' do
    subject { signator.signature }

    let(:signature) { 'bkXeOz0UEyH9VhwWQEZJVWHRsC1a4GXYUD5KidbNQyc=' }

    it { is_expected.to eq(signature) }
  end
end
