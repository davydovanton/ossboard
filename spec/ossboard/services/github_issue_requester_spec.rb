RSpec.describe GithubIssueRequester, :vcr do
  let(:params) { {} }

  context 'when data is valid' do
    let(:params) { { org: 'hanami', repo: 'hanami', issue: '663' } }

    it 'returns github issue data' do
      VCR.use_cassette("github_success_issue") do
        data = GithubIssueRequester.(params)
        expect(data[:html_url]).to eq 'https://github.com/hanami/hanami/issues/663'
        expect(data[:title]).to eq 'Format resolving and Template lookup'
        expect(data[:description]).to match('As was reported on Gitter')
        expect(data[:lang]).to eq 'ruby'
        expect(data[:repository_name]).to eq 'hanami'
      end
    end
  end

  context 'when data is invalid' do
    let(:params) { { org: 'hanam', repo: 'anami', issue: '63' } }

    it 'returns github issue data' do
      VCR.use_cassette("github_failed_issue") do
        data = GithubIssueRequester.(params)
        expect(data).to eq(error: 'invalid url')
      end
    end
  end
end
