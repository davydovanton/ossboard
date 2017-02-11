require_relative '../../../../apps/web/controllers/tasks/update'

RSpec.describe Web::Controllers::Tasks::Update do
  let(:repo) { TaskRepository.new }
  let(:task) { Fabricate.create(:task, title: 'title')}
  let(:user) { User.new(login: 'test') }
  let(:session) { { current_user: user } }
  let(:action) { described_class.new }
  let(:params) { { id: task.id } }

  after { repo.clear }

  context 'when user in not authenticated' do
    let(:params) { { id: task.id, task: { title: 'test', description: 'This is *bongos*, indeed.', lang: 'test' }, 'rack.session' => session } }

    it { expect(action.call(params)).to redirect_to("/tasks/#{task.id}") }

    it 'does not create new task' do
      action.call(params)
      expect(repo.find(task.id).title).to eq 'title'
    end

    it 'sets error flash message' do
      action.call(params)
      flash = action.exposures[:flash]
      expect(flash[:error]).to eq "You doesn't have access for editing this task"
    end
  end

  context 'when user authenticated and try to edit not its task' do
    let(:user) { Fabricate.create(:user, name: 'anton', login: 'test') }
    let(:task) { Fabricate.create(:task, title: 'title', user_id: user.id - 1) }
    let(:params) { { id: task.id, task: { title: 'test', description: 'This is *bongos*, indeed.', lang: 'test' }, 'rack.session' => session } }

    it { expect(action.call(params)).to redirect_to("/tasks/#{task.id}") }

    it 'does not create new task' do
      action.call(params)
      expect(repo.find(task.id).title).to eq 'title'
    end

    it 'sets error flash message' do
      action.call(params)
      flash = action.exposures[:flash]
      expect(flash[:error]).to eq "You doesn't have access for editing this task"
    end
  end

  context 'when user try to edit approved task' do
    let(:user) { Fabricate.create(:user, name: 'anton', login: 'test') }
    let(:task) { Fabricate.create(:task, title: 'title', user_id: user.id, approved: true) }
    let(:params) { { id: task.id, task: { title: 'test', description: 'This is *bongos*, indeed.', lang: 'test' }, 'rack.session' => session } }

    it { expect(action.call(params)).to redirect_to("/tasks/#{task.id}") }

    it 'does not update task' do
      action.call(params)
      expect(repo.find(task.id).title).to eq 'title'
    end

    it 'sets error flash message' do
      action.call(params)
      flash = action.exposures[:flash]
      expect(flash[:error]).to eq "You doesn't have access for editing this task"
    end
  end

  context 'when user edit its unapproved task' do
    let(:user) { Fabricate.create(:user, name: 'anton', login: 'test') }
    let(:task) { Fabricate.create(:task, title: 'title', user_id: user.id, approved: false) }
    let(:params) { { id: task.id, task: task_params, 'rack.session' => session } }

    context 'and params valid' do
      let(:task_params) do
        {
          title: 'test',
          repository_name: 'Acme-Project',
          description: 'This is *bongos*, indeed.',
          lang: 'test',
          user_id: user.id,
          issue_url: 'github.com/issue/1'
        }
      end

      after { UserRepository.new.clear }

      it 'sets error flash message' do
        action.call(params)
        flash = action.exposures[:flash]
        expect(flash[:info]).to eq 'Task had been updated.'
      end

      it { expect(action.call(params)).to redirect_to("/tasks/#{task.id}") }

      it 'updates task' do
        action.call(params)
        updated_task = repo.find(task.id)
        expect(updated_task.title).to eq 'test'
        expect(updated_task.repository_name).to eq 'Acme-Project'
        expect(updated_task.description).to eq 'This is *bongos*, indeed.'
        expect(updated_task.body).to eq "<p>This is <em>bongos</em>, indeed.</p>\n"
        expect(updated_task.issue_url).to eq 'github.com/issue/1'
      end

      context 'when issue url and repository name empty' do
        let(:task_params) do
          {
            title: 'test',
            repository_name: '',
            description: 'This is *bongos*, indeed.',
            lang: 'test',
            user_id: user.id,
            issue_url: ''
          }
        end

        it 'updates task' do
          action.call(params)
          updated_task = repo.find(task.id)
          expect(updated_task.title).to eq 'test'
          expect(updated_task.repository_name).to eq nil
          expect(updated_task.description).to eq 'This is *bongos*, indeed.'
          expect(updated_task.body).to eq "<p>This is <em>bongos</em>, indeed.</p>\n"
          expect(updated_task.issue_url).to eq nil
        end
      end
    end

    describe 'and params invalid' do
      let(:user) { Fabricate.create(:user, name: 'anton', login: 'test') }
      let(:task) { Fabricate.create(:task, title: 'title', user_id: user.id, approved: false) }
      let(:params) { { id: task.id, task: {}, 'rack.session' => session } }

      it { expect(action.call(params)).to have_http_status(200) }
      it { expect(action.call(params)).to match_in_body(/Title is missing/) }
      it { expect(action.call(params)).to match_in_body(/Description is missing/) }

      it 'does not update task' do
        action.call(params)
        expect(repo.find(task.id).title).to eq 'title'
      end
    end
  end
end
