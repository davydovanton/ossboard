require_relative '../../../../apps/api/controllers/issue/show'

RSpec.describe Api::Controllers::Issue::Show do
  let(:action) { described_class.new }
  let(:params) { {} }

  it { expect(action.call(params)).to be_success }

  context 'when params does not contain issue url' do
    let(:params) { { issue_url: nil } }
    it { expect(action.call(params)).to match_in_body(/\A{"error":"empty url"}\z/) }
  end

  context 'when issue url is empty' do
    let(:params) { { issue_url: '' } }
    it { expect(action.call(params)).to match_in_body(/\A{"error":"empty url"}\z/) }
  end

  context 'when issue url is valid' do
    let(:params) { { issue_url: 'https://github.com/hanami/hanami/issues/663' } }
    it { expect(action.call(params)).to match_in_body(/\A{"host":"gitub","org":"hanami","repo":"hanami","issue":"663"}\z/) }
  end

  context 'when issue url is invalid' do
    let(:params) { { issue_url: 'https://api.github.com/repos/hanami/hanami/issues/663' } }
    it { expect(action.call(params)).to match_in_body(/\A{"error":"invalid url"}\z/) }
  end
end
