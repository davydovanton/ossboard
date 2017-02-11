require_relative '../../../../apps/web/controllers/tasks/create'

RSpec.describe Admin::Controllers::Tasks::Update do
  let(:action) { described_class.new }
  let(:repo) { TaskRepository.new }
  let(:task) { Fabricate.create(:task, title: 'old', body: nil) }
  let(:session) { { current_user: User.new(id: 1, admin: true) } }

  after { repo.clear }

  describe 'when params valid' do
    let(:params) { { id: task.id, task: task_params, 'rack.session' => session } }
    let(:task_params) do
      {
        title: 'test',
        repository_name: 'Acme-Project',
        description: 'This is *bongos*, indeed.',
        lang: 'ruby',
        assignee_username: 'davydovanton',
        complexity: 'medium',
        time_estimate: 'more than month',
        issue_url: 'github.com/issue/1',
        approved: '1',
        status: 'done'
      }
    end

    it { expect(action.call(params)).to redirect_to("/admin/tasks/#{task.id}") }

    it 'updates task' do
      action.call(params)
      task = repo.last
      expect(task.title).to eq 'test'
      expect(task.repository_name).to eq 'Acme-Project'
      expect(task.description).to eq 'This is *bongos*, indeed.'
      expect(task.body).to eq "<p>This is <em>bongos</em>, indeed.</p>\n"
      expect(task.approved).to eq true
      expect(task.assignee_username).to eq 'davydovanton'
      expect(task.lang).to eq 'ruby'
      expect(task.complexity).to eq 'medium'
      expect(task.time_estimate).to eq 'more than month'
      expect(task.issue_url).to eq 'github.com/issue/1'
      expect(task.status).to eq 'done'
    end

    context 'when issue url and repository name empty' do
      let(:task_params) do
        {
          title: 'test',
          repository_name: '',
          description: 'This is *bongos*, indeed.',
          lang: 'ruby',
          complexity: 'medium',
          time_estimate: 'more than month',
          issue_url: '',
          approved: '1',
          status: 'done'
        }
      end

      it { expect(action.call(params)).to redirect_to("/admin/tasks/#{task.id}") }

      it 'updates task' do
        action.call(params)
        task = repo.last
        expect(task.title).to eq 'test'
        expect(task.repository_name).to eq nil
        expect(task.description).to eq 'This is *bongos*, indeed.'
        expect(task.body).to eq "<p>This is <em>bongos</em>, indeed.</p>\n"
        expect(task.approved).to eq true
        expect(task.lang).to eq 'ruby'
        expect(task.complexity).to eq 'medium'
        expect(task.time_estimate).to eq 'more than month'
        expect(task.issue_url).to eq nil
      end
    end
  end

  describe 'when params invalid' do
    let(:params) { { id: task.id, 'rack.session' => session } }

    it { expect(action.call(params)).to have_http_status(422) }

    it 'does not update task' do
      action.call(params)
      task = repo.last
      expect(task.title).to eq 'old'
      expect(task.body).to eq nil
    end
  end
end
