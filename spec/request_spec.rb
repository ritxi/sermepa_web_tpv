require 'spec_helper'

class Transaction
  attr_accessor :transaction_number, :amount
  attr_reader :save

  def initialize(amount)
    @amount = amount
  end

  def update_attribute(field, value)
    send("#{field}=", value)
  end

  def new_record?
    true
  end

  def transaction_number
    '1442772645'
  end
end

describe SermepaWebTpv::Request do
  let(:transaction) { Transaction.new(145) }
  let(:request) { SermepaWebTpv::Request.new(transaction, 'Description') }
  let(:options) do
    { 'DS_MERCHANT_AMOUNT' => '145',
      'DS_MERCHANT_ORDER' => '1442772645',
      'DS_MERCHANT_MERCHANTCODE' => '999008881',
      'DS_MERCHANT_CURRENCY' => '978',
      'DS_MERCHANT_TRANSACTIONTYPE' => '0',
      'DS_MERCHANT_TERMINAL' => '871',
      'DS_MERCHANT_MERCHANTURL' => 'https://ejemplo/ejemplo_URL_Notif.php',
      'DS_MERCHANT_URLOK' => 'https://ejemplo/ejemplo_URL_OK_KO.php',
      'DS_MERCHANT_URLKO' => 'https://ejemplo/ejemplo_URL_OK_KO.php' }
  end

  describe '#transact' do
    subject { request.transact(&:save) }

    it { is_expected.to eq(transaction) }
  end

  describe '#params' do
    subject { request.params }
    let(:merchant_params) do
      'eyJEc19NZXJjaGFudF9UaXR1bGFyIjoiVU5JTyBFWENVUlNJT05JU1RBIiwiRHNf' \
      'TWVyY2hhbnRfVXJsS08iOiJodHRwczovL215LWNvbWVyY2UuY29tL3NhbXBsZV9V' \
      'UkxfT0tfS08ucGhwIiwiRHNfTWVyY2hhbnRfVXJsT0siOiJodHRwczovL215LWNv' \
      'bWVyY2UuY29tL3NhbXBsZV9VUkxfT0tfS08ucGhwIiwiRHNfTWVyY2hhbnRfQW1v' \
      'dW50IjoiMTQ1MDAiLCJEc19NZXJjaGFudF9PcmRlciI6IjE0NDI3NzI2NDUiLCJE' \
      'c19NZXJjaGFudF9Qcm9kdWN0RGVzY3JpcHRpb24iOiJEZXNjcmlwdGlvbiIsIkRz' \
      'X01lcmNoYW50X0N1cnJlbmN5Ijo5NzgsIkRzX01lcmNoYW50X01lcmNoYW50Q29k' \
      'ZSI6Ijk5OTAwODg4MSIsIkRzX01lcmNoYW50X1Rlcm1pbmFsIjoxLCJEc19NZXJj' \
      'aGFudF9UcmFuc2FjdGlvblR5cGUiOjAsIkRzX01lcmNoYW50X0NvbnN1bWVyTGFu' \
      'Z3VhZ2UiOiIwMDMiLCJEc19NZXJjaGFudF9NZXJjaGFudFVSTCI6Imh0dHBzOi8v' \
      'bXktY29tZXJjZS5jb20vc2FtcGxlX1VSTF9Ob3RpZi5waHAifQ=='
    end
    let(:params) do
      {
        'Ds_SignatureVersion' => 'HMAC_SHA256_V1',
        'Ds_MerchantParameters' => merchant_params,
        'Ds_Signature' => 'ZviPEhkVr7YtadksrpEnw+bTMj4iK3E6Tte2+KFh8Qw='
      }
    end
    it { is_expected.to eq(params) }
  end

  describe '#merchant_parameters_json' do
    before { expect(request).to receive(:options).and_return(options) }
    subject { request.merchant_parameters_json }
    let(:json) do
      '{"DS_MERCHANT_AMOUNT":"145",' \
      '"DS_MERCHANT_ORDER":"1442772645",' \
      '"DS_MERCHANT_MERCHANTCODE":"999008881",' \
      '"DS_MERCHANT_CURRENCY":"978",' \
      '"DS_MERCHANT_TRANSACTIONTYPE":"0",' \
      '"DS_MERCHANT_TERMINAL":"871",' \
      '"DS_MERCHANT_MERCHANTURL":"https://ejemplo/ejemplo_URL_Notif.php",' \
      '"DS_MERCHANT_URLOK":"https://ejemplo/ejemplo_URL_OK_KO.php",' \
      '"DS_MERCHANT_URLKO":"https://ejemplo/ejemplo_URL_OK_KO.php"}'
    end

    it { is_expected.to eq(json) }
  end

  describe '#merchant_parameters' do
    before { expect(request).to receive(:options).and_return(options) }
    subject { request.merchant_parameters }
    let(:base64_params) do
      Base64.encode64(
        '{"DS_MERCHANT_AMOUNT":"145",' \
        '"DS_MERCHANT_ORDER":"1442772645",' \
        '"DS_MERCHANT_MERCHANTCODE":"999008881",' \
        '"DS_MERCHANT_CURRENCY":"978",' \
        '"DS_MERCHANT_TRANSACTIONTYPE":"0",' \
        '"DS_MERCHANT_TERMINAL":"871",' \
        '"DS_MERCHANT_MERCHANTURL":"https://ejemplo/ejemplo_URL_Notif.php",' \
        '"DS_MERCHANT_URLOK":"https://ejemplo/ejemplo_URL_OK_KO.php",' \
        '"DS_MERCHANT_URLKO":"https://ejemplo/ejemplo_URL_OK_KO.php"}').split("\n").join('')
    end

    it { is_expected.to eq(base64_params) }
  end
end