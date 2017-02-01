RSpec.describe ApproveTaskWorker do
  let(:task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id) }
  subject { ApproveTaskWorker.new }

  after do
    TaskRepository.new.clear
    UserRepository.new.clear
  end

  describe '#perform' do
    it 'sends email to all admins' do
      expect{ subject.perform(task.id) }.to change { Hanami::Mailer.deliveries.size }.by(1)
    end

    it 'calls approved task twitter services' do
      expect(TaskTwitter).to receive(:call).with(task)
      subject.perform(task.id)
    end
  end
end
