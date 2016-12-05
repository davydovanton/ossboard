require_relative '../../../../apps/admin/views/tasks/index'

RSpec.describe Admin::Views::Tasks::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/tasks/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:repo)      { TaskRepository.new }

  describe '#tasks' do
    before do
      3.times { repo.create(title: 'good', approved: false) }
      3.times { repo.create(title: 'good', approved: true) }
    end

    after { repo.clear }

    it 'returns all tasks' do
      expect(view.tasks).to eq repo.all
    end
  end

  describe '#link_to_task' do
    let(:task) { Task.new(id: 1, title: 'test') }

    it 'returns link to special task' do
      link = view.link_to_task(task)
      expect(link.to_s).to eq '<a href="/admin/tasks/1">test</a>'
    end
  end

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be false }
    it { expect(view.moderation_active?).to be false }
    it { expect(view.tasks_active?).to be true }
    it { expect(view.users_active?).to be false }
  end

  describe '#task_label' do
    context 'when task approved' do
      let(:task) { Task.new(id: 1, title: 'test', approved: true) }
      it { expect(view.task_label(task).to_s).to eq "<span class=\"label label-success\">\nApproved\n</span>" }
    end

    context 'when task not approved' do
      let(:task) { Task.new(id: 1, title: 'test', approved: false) }
      it { expect(view.task_label(task).to_s).to eq "<span class=\"label label-danger\">\nUnapproved\n</span>" }
    end
  end
end
