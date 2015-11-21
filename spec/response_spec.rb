require 'spec_helper'

describe SermepaWebTpv::Response do
  let(:merchant_params) do
    Base64.urlsafe_encode64({
      'Ds_Order' => '1442772645',
      'Ds_Response' => '0'
    }.to_json).split("\n").join('')
  end

  let(:signature) do
    'Kl27JT6ZK46E8CdLJOTg3+fv9yBXamKoIr3pIHi7i90='
  end

  let(:params) do
    {
      'Ds_MerchantParameters' => merchant_params,
      'Ds_Signature' => signature
    }
  end

  subject { described_class.new(params) }
  it { is_expected.to be_valid }
  it { is_expected.to be_success }
  it { expect(subject.signature).to eq(signature) }
end

