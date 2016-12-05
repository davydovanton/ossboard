require 'spec_helper'
require_relative '../../../../apps/admin/views/tasks/show'

RSpec.describe Admin::Views::Tasks::Show do
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/tasks/show.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  let(:task) { Task.new(id: 1, title: 'test') }
  let(:exposures) { Hash[task: task] } 

  describe '#link_to_edit' do
    it 'returns link to special task' do
      link = view.link_to_edit
      expect(link.to_s).to eq '<a class="pure-button pure-button-primary" href="/admin/tasks/1/edit">Edit task</a>'
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
      it { expect(view.task_label.to_s).to eq "<span class=\"label label-success\">\nApproved\n</span>" }
    end

    context 'when task not approved' do
      let(:task) { Task.new(id: 1, title: 'test', approved: false) }
      it { expect(view.task_label.to_s).to eq "<span class=\"label label-danger\">\nUnapproved\n</span>" }
    end
  end
end
