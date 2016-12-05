require 'spec_helper'
require_relative '../../../../apps/admin/views/moderation/index'

RSpec.describe Admin::Views::Moderation::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/moderation/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  let(:repo)      { TaskRepository.new }

  describe '#tasks' do
    before do
      3.times { repo.create(title: 'good', approved: false) }
      3.times { repo.create(title: 'good', approved: true) }
    end

    after { repo.clear }

    it 'returns only not approved tasks' do
      expect(view.tasks.count).to eq 3
      expect(view.tasks.last.approved).to eq false
    end
  end

  describe '#approve_task_button' do
    let(:task) { Task.new(id: 1) }

    it { expect(view.approve_task_button(task)).to have_method(:patch) }
    it { expect(view.approve_task_button(task)).to have_action('/admin/moderation/1') }
  end

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be false }
    it { expect(view.moderation_active?).to be true }
    it { expect(view.tasks_active?).to be false }
    it { expect(view.users_active?).to be false }
  end
end
