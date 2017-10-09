RSpec.describe UserRepository do
  let(:repo) { UserRepository.new }

  describe '#find_by_login' do
    context 'when user exist with uuid' do
      before { Fabricate.create(:user, login: 'test') }

      it { expect(repo.find_by_login('test')).to be_a User }
      it { expect(repo.find_by_login('test').login).to eq 'test' }
    end

    context 'when user not exist with uuid' do
      it { expect(repo.find_by_login('test2')).to eq nil }
    end
  end

  describe '#admins' do
    before do
      3.times { Fabricate.create(:user) }
      3.times { Fabricate.create(:user, admin: true) }
    end

    it { expect(repo.admins).to all(be_a(User)) }
    it { expect(repo.admins.map(&:admin)).to eq [true, true, true] }
  end

  describe '#all_from_date' do
    before do
      5.times do |i|
        random_days_count = i * 60 * 60 * 24
        Timecop.freeze(Time.new(2016, 02, 20) - random_days_count) { Fabricate.create(:user) }
      end

      Timecop.freeze(Time.now + (2 * 60 * 60 * 24)) { Fabricate.create(:user) }
    end

    let(:date) { Date.new(2016, 02, 17) }

    it { expect(repo.all_from_date(date)).to be_a(Array) }
    it { expect(repo.all_from_date(date).count).to eq 3 }
  end

  describe '#count_all_from_date' do
    before do
      Timecop.freeze(Time.utc(2016, 02, 16)) { Fabricate.create(:user) }
      Timecop.freeze(Time.utc(2016, 02, 19)) { Fabricate.create(:user) }
      Timecop.freeze(Time.utc(2016, 02, 20)) do
        Fabricate.create(:user)
        Fabricate.create(:user)
      end
    end

    let(:date) { Date.new(2016, 02, 17) }
    let(:result) { repo.count_all_from_date(date) }

    it { expect(result).to be_a(Hash) }
    it { expect(result[Date.new(2016, 02, 16)]).to be nil }
    it { expect(result[Date.new(2016, 02, 20)]).to eq 2 }
  end

  describe '#find_by_login_with_tasks' do
    let(:task_repo) { TaskRepository.new }

    let(:user) { Fabricate.create(:user, uuid: 'test', login: 'davydovanton') }

    before do
      Fabricate.create(:task, title: 'bad', user_id: user.id )
      Fabricate.create(:task, title: 'good', approved: true)
    end

    subject { repo.find_by_login_with_tasks(user.login) }

    it { expect(subject.tasks).to be_a Array }
    it { expect(subject.tasks.count).to eq 1 }
  end

  describe '#find_with_tasks' do
    let(:task_repo) { TaskRepository.new }

    let(:user) { Fabricate.create(:user, uuid: 'test') }

    before do
      Fabricate.create(:task, title: 'bad', user_id: user.id )
      Fabricate.create(:task, title: 'good', approved: true)
    end

    subject { repo.find_with_tasks(user.id) }

    it { expect(subject.tasks).to be_a Array }
    it { expect(subject.tasks.count).to eq 1 }
  end
end
