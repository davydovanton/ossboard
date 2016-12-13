RSpec.describe UserRepository do
  let(:repo) { UserRepository.new }

  after { repo.clear }

  describe '#find_by_uuid' do
    context 'when user exist with uuid' do
      before { repo.create(uuid: 'test') }

      it { expect(repo.find_by_uuid('test')).to be_a User }
      it { expect(repo.find_by_uuid('test').uuid).to eq 'test' }
    end

    context 'when user not exist with uuid' do
      it { expect(repo.find_by_uuid('test2')).to eq nil }
    end
  end

  describe '#find_with_tasks' do
    let(:task_repo) { TaskRepository.new }

    let(:user) { repo.create(uuid: 'test') }

    before do
      task_repo.create(title: 'bad', user_id: user.id )
      task_repo.create(title: 'good', approved: true)
    end

    subject { repo.find_with_tasks(user.id) }

    it { expect(subject.tasks).to be_a Array }
    it { expect(subject.tasks.count).to eq 1 }
  end
end
