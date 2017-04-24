RSpec.describe TaskTwitter do
  let(:task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id) }

  subject { TaskTwitter.new.call(task) }

  after do
    TaskRepository.new.clear
    UserRepository.new.clear
  end

  describe '#call' do
    context 'with correct text' do
      let(:task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id) }

      it 'sends tweet' do
        VCR.use_cassette("task_twitter_sender") do
          expected_text = "#{task.title} #ossboard https://is.gd/DHouda"
          expect(subject).to eq expected_text
        end
      end
    end

    context 'when title long' do
      let(:task) { Fabricate.create(:task, title: Faker::Lorem.paragraph, user_id: Fabricate.create(:user).id) }

      it { VCR.use_cassette("task_twitter_sender") { expect(subject.size).to be <= 140 } }
    end
  end

  it "#twitter_client returs a twitter client" do
    expect(Container[:twitter]).to be_a(Twitter::REST::Client)
  end
end
