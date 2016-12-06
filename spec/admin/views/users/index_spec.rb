require_relative '../../../../apps/admin/views/users/index'

RSpec.describe Admin::Views::Users::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/users/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:repo)      { UserRepository.new }

  describe 'users' do
    before do
      3.times { repo.create(name: 'Anton') }
    end

    after { repo.clear }

    it 'returns all users' do
      expect(view.users).to eq repo.all
    end
  end

  describe '#link_to_user' do
    let(:user) { User.new(id: 1, name: 'test') }

    it 'returns link to special user' do
      link = view.link_to_user(user)
      expect(link.to_s).to eq '<a href="/admin/users/1">test</a>'
    end
  end

  describe '#user_role' do
    context 'when user admin' do
      let(:user) { User.new(admin: true) }
      it { expect(view.user_role(user)).to eq 'admin' }
    end

    context 'when user not admin' do
      let(:user) { User.new(admin: false) }
      it { expect(view.user_role(user)).to eq 'user' }
    end
  end

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be false }
    it { expect(view.moderation_active?).to be false }
    it { expect(view.tasks_active?).to be false }
    it { expect(view.users_active?).to be true }
  end
end
