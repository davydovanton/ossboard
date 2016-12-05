require_relative '../../../../apps/admin/views/tasks/edit'

RSpec.describe Admin::Views::Tasks::Edit do
  let(:task)      { Task.new(id: 1, title: 'test', body: 'test') }
  let(:exposures) { Hash[task: task] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/tasks/edit.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  describe '#form' do
    it { expect(view.form).to have_method(:patch) }
    it { expect(view.form).to have_action('/admin/tasks/1') }
  end

  describe '#checkbox_status' do
    context 'when task not approved' do
      it { expect(view.checkbox_status).to eq nil }
    end

    context 'when task approved' do
      let(:task) { Task.new(id: 1, title: 'test', body: 'test', approved: true) }
      it { expect(view.checkbox_status).to eq 'checked' }
    end
  end

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be false }
    it { expect(view.moderation_active?).to be false }
    it { expect(view.tasks_active?).to be true }
    it { expect(view.users_active?).to be false }
  end
end
