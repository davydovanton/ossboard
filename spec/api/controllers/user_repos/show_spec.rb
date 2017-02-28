require_relative '../../../../apps/api/controllers/user_repos/show'

RSpec.describe Api::Controllers::UserRepos::Show do
  let(:action) { described_class.new }
  let(:params) { Hash[login: 'davydovanton'] }

  subject do
    VCR.use_cassette("user_github_repos") { action.call(params) }
  end

  context 'when params invalid' do
    let(:params) { Hash[] }
    it { expect(subject).to_not be_success }
  end

  context 'when params valid' do
    it { expect(subject).to be_success }
  end

  context 'user repositories come back as json' do
    let(:repos) { subject[2][0] }
    it { expect(repos.class).to eq(String) }
  end

  context 'user repositories are not paginated to 100' do
    let(:repos_count) { JSON.parse(subject[2][0]).count }
    it { expect(repos_count).to be > 100 }
  end
end
