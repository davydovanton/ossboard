require_relative '../../../../apps/web/controllers/tasks/create'

RSpec.describe Web::Controllers::Tasks::CreateParams do
  subject { described_class.new(task: params) }

  let(:params) do
    {
      title: 'test',
      repository_name: 'Acme-Project',
      description: 'This is *bongos*, indeed.',
      lang: 'test',
      complexity: 'easy',
      time_estimate: 'few days',
      user_id: 123,
      issue_url: 'github.com/issue/1'
    }
  end

  describe "valid params" do
    it 'success' do
      expect(subject.valid?).to be(true)
    end
  end

  describe "md body is empty" do
    before { params[:description] = "" }

    it "correct validation message" do
      expect(subject.error_messages[0]).to eq("Description must be filled")
    end
  end
end
