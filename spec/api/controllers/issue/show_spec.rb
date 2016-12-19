require_relative '../../../../apps/api/controllers/issue/show'

RSpec.describe Api::Controllers::Issue::Show, :vcr do
  let(:action) { described_class.new }
  let(:params) { {} }

  subject do
    VCR.use_cassette("github_success_issue") { action.call(params) }
  end

  it { expect(action.call(params)).to be_success }

  context 'when params does not contain issue url' do
    let(:params) { { issue_url: nil } }
    it { expect(subject).to match_in_body(/\A{"error":"empty url"}\z/) }
  end

  context 'when issue url is empty' do
    let(:params) { { issue_url: '' } }
    it { expect(subject).to match_in_body(/\A{"error":"empty url"}\z/) }
  end

  context 'when issue url is valid' do
    let(:params) { { issue_url: 'https://github.com/hanami/hanami/issues/663' } }
    it { expect(subject).to match_in_body(/"title":/) }
    it { expect(subject).to match_in_body(/"body":/) }
    it { expect(subject).to match_in_body(/"html_url":/) }
  end

  context 'when issue url is invalid' do
    let(:params) { { issue_url: 'https://api.github.com/repos/hanami/hanami/issues/663' } }
    it { expect(subject).to match_in_body(/\A{"error":"invalid url"}\z/) }
  end
end
