require 'spec_helper'
require_relative '../../../../apps/admin/views/tasks/update'

RSpec.describe Admin::Views::Tasks::Update do
  let(:task)      { Task.new(id: 1, title: 'test', body: 'test') }
  let(:exposures) { Hash[task: task] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/tasks/edit.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be false }
    it { expect(view.moderation_active?).to be false }
    it { expect(view.tasks_active?).to be true }
    it { expect(view.users_active?).to be false }
  end
end
