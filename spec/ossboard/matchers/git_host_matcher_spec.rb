RSpec.describe GitHostMatcher do
  subject do
    GitHostMatcher.(issue_url) do |m|
      m.success(:github){ |params| params }
      m.failure { |params| params }
    end
  end

  context 'when string is github issue' do
    let(:issue_url) { 'https://github.com/hanami/hanami/issues/663' }
    it { expect(subject).to eq(org: 'hanami', repo: 'hanami', issue: '663') }
  end

  context 'when string is other github issue' do
    let(:issue_url) { 'https://github.com/davydovanton/sidekiq-statistic/issues/75' }
    it { expect(subject).to eq(org: 'davydovanton', repo: 'sidekiq-statistic', issue: '75') }
  end

  context 'when string is github issue' do
    let(:issue_url) { 'https://api.github.com/repos/hanami/hanami/issues/663' }
    it { expect(subject).to eq(error: 'invalid url') }
  end
end
