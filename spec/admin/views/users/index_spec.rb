require_relative '../../../../apps/admin/views/users/index'

RSpec.describe Admin::Views::Users::Index, type: :view do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/users/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:repo)      { UserRepository.new }

  before do
    Container[:redis].with(&:flushdb)
  end

  describe 'users' do
    before do
      3.times { Fabricate.create(:user, name: 'Anton') }
    end

    it 'returns all users' do
      expect(view.users).to eq repo.all.reverse
    end
  end

  describe '#link_to_user' do
    let(:user) { User.new(id: 1, name: 'test') }

    it 'returns link to special user' do
      link = view.link_to_user(user)
      expect(link.to_s).to eq '<a href="/admin/users/1">test</a>'
    end
  end

  describe '#banned_users' do
    it { expect(view.banned_users).to eq [] }
  end

  describe '#link_to_block' do
    let(:user) { User.new(id: 1, login: 'davydovanton') }

    context 'when user not banned' do
      it { expect(view.link_to_block(user).to_s).to eq(
           '<form action="/admin/users/1" method="POST">' + "\n" +
           '<input type="hidden" name="_method" value="DELETE">' + "\n" +
           '<input type="hidden" name="login" value="davydovanton">' + "\n" +
           '<input class="pure-button pure-button-danger" type="submit" value="Block">' + "\n" +
           '</form>') }
    end

    context 'when user banned' do
      before { BlokedUserRepository.new.create('davydovanton') }

      it { expect(view.link_to_block(user).to_s).to eq(
           '<form action="/admin/unban_users/1" method="POST">' + "\n" +
           '<input type="hidden" name="_method" value="PATCH">' + "\n" +
           '<input type="hidden" name="login" value="davydovanton">' + "\n" +
           '<input class="pure-button pure-button-green" type="submit" value="Unblock">' + "\n" +
           '</form>') }
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
