require_relative '../../../../apps/admin/views/dashboard/index'

RSpec.describe Admin::Views::Dashboard::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/dashboard/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    expect(view.foo).to eq exposures.fetch(:foo)
  end

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be true }
    it { expect(view.moderation_active?).to be false }
    it { expect(view.tasks_active?).to be false }
    it { expect(view.users_active?).to be false }
  end
end
