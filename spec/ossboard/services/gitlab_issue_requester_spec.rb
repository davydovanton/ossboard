RSpec.describe GitlabIssueRequester, :vcr do
  let(:params) { {} }

  context 'when data is valid' do
    let(:params) { { org: 'gitlab-org', repo: 'gitlab-ce', issue: '27371' } }

    it 'returns gitlab issue data' do
      VCR.use_cassette("gitlab_success_issue") do
        data = subject.(params)
        expect(data[:html_url]).to eq 'https://gitlab.com/gitlab-org/gitlab-ce/issues/27371'
        expect(data[:title]).to eq "Set protected branches \"Allowed to push\" to \"No one\" via API"
        expect(data[:description]).to match('To keep the API similar ')
        expect(data[:repository_name]).to eq 'GitLab Community Edition'
      end
    end
  end

  context 'when data is invalid' do
    let(:params) { { org: 'gitlab-org', repo: 'gitlab-ce-', issue: '27371' } }

    it 'returns invalid url message' do
      VCR.use_cassette("gitlab_failed_issue") do
        data = subject.(params)
        expect(data).to eq(error: 'invalid url')
      end
    end
  end

 context 'when data is not authorized' do
    let(:params) { { org: 'gitlab-org', repo: 'gitlab-ce', issue: '27371' } }

    it 'returns unathorized messages' do
      VCR.use_cassette("gitlab_unathorized_issue") do
        data = subject.(params)
        expect(data).to eq(error: 'Unauthorized')
      end
    end
  end
end
