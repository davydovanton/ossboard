require_relative '../../../../apps/web/controllers/tasks/create'

RSpec.describe Web::Controllers::Tasks::Create do
  let(:action) { described_class.new }
  let(:repo) { TaskRepository.new }
  let(:session) { { current_user: User.new(id: 1, login: 'test') } }

  describe 'when user in not authenticated' do
    let(:params) { { task: { title: 'test', md_body: 'This is *bongos*, indeed.',
                             lang: 'test', complexity: 'easy', first_pr: true } } }

    it { expect(action.call(params)).to have_http_status(200) }

    it 'does not create new task' do
      expect { action.call(params) }.to change { repo.all.size }.by(0)
    end
  end

  describe 'when params valid' do
    let(:user) { Fabricate.create(:user, name: 'test', login: 'davydovanton') }
    let(:params) { { task: task_params, 'rack.session' => session } }
    let(:task_params) do
      {
        title: 'test',
        repository_name: 'Acme-Project',
        md_body: 'This is *bongos*, indeed.',
        lang: 'test',
        complexity: 'easy',
        time_estimate: 'few days',
        user_id: user.id,
        first_pr: true,
        issue_url: 'github.com/issue/1'
      }
    end

    it 'sets error flash message' do
      action.call(params)
      flash = action.exposures[:flash]
      expect(flash[:info]).to eq 'Task had been added to moderation. You can check your task status on profile page'
    end

    it { expect(action.call(params)).to redirect_to('/tasks') }

    context 'sends email to admin users' do
      before { Fabricate.create(:user, admin: true) }
      it { expect{ action.call(params) }.to change { NewTaskNotificationWorker.jobs.size }.by(1) }
    end

    it 'creates new task' do
      expect { action.call(params) }.to change { repo.all.size }.by(1)

      task = repo.last
      expect(task.title).to eq 'test'
      expect(task.repository_name).to eq 'Acme-Project'
      expect(task.md_body).to eq 'This is *bongos*, indeed.'
      expect(task.body).to eq "<p>This is <em>bongos</em>, indeed.</p>\n"
      expect(task.issue_url).to eq 'github.com/issue/1'
      expect(task.status).to eq 'in progress'
      expect(task.approved).to eq nil
      expect(task.first_pr).to eq true
    end

    context 'when issue url and repository name empty' do
      let(:task_params) do
        {
          title: 'test',
          repository_name: '',
          md_body: 'This is *bongos*, indeed.',
          lang: 'test',
          complexity: 'easy',
          time_estimate: 'few days',
          user_id: user.id,
          first_pr: false,
          issue_url: ''
        }
      end

      it 'creates new task' do
        expect { action.call(params) }.to change { repo.all.size }.by(1)

        task = repo.last
        expect(task.title).to eq 'test'
        expect(task.repository_name).to eq nil
        expect(task.md_body).to eq 'This is *bongos*, indeed.'
        expect(task.body).to eq "<p>This is <em>bongos</em>, indeed.</p>\n"
        expect(task.issue_url).to eq nil
        expect(task.complexity).to eq 'easy'
        expect(task.time_estimate).to eq 'few days'
        expect(task.status).to eq 'in progress'
        expect(task.approved).to eq nil
        expect(task.first_pr).to eq false
      end
    end
  end

  describe 'when user is not login' do
    let(:params) { { task: { title: 'test', md_body: 'This is *bongos*, indeed.', lang: 'test', complexity: 'easy', user_id: nil }, 'rack.session' => session } }

    it { expect(action.call(params)).to have_http_status(200) }
    it { expect(action.call(params)).to match_in_body('User Id must be filled') }

    it 'does not create new task' do
      expect { action.call(params) }.to change { repo.all.size }.by(0)
    end
  end

  describe 'when params invalid' do
    let(:params) { { task: {}, 'rack.session' => session } }

    it { expect(action.call(params)).to have_http_status(200) }
    it { expect(action.call(params)).to match_in_body('Title is missing') }
    it { expect(action.call(params)).to match_in_body(/Body is missing/) }

    it 'does not create new task' do
      expect { action.call(params) }.to change { repo.all.size }.by(0)
    end
  end
end
