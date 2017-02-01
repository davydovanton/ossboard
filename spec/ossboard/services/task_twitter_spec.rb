RSpec.describe TaskTwitter do
  let(:task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id) }
  let(:task_with_long_title) do
    Fabricate.create(:task, title: Faker::Lorem.paragraph, user_id: Fabricate.create(:user).id)
  end

  subject { TaskTwitter.new }

  after do
    TaskRepository.new.clear
    UserRepository.new.clear
  end

  describe '#perform' do
    it 'calls tweet with correct text' do
      expected_text = "#{task.title} #ossboard http://www.ossboard.org/tasks/#{task.id}"
      expect(subject).to receive(:tweet).with(expected_text)
      subject.(task)
    end

    it 'Slices title if it is too long' do
      expect(subject).to receive(:tweet) { |tweet| expect(tweet.size).to be <= 140 }
      subject.(task_with_long_title)
    end
  end

  it "#twitter_client returs a twitter client" do
    expect(subject.twitter_client).to be_a(Twitter::REST::Client)
  end
end
