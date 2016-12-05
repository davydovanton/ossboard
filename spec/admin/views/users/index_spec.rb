require_relative '../../../../apps/admin/views/users/index'

RSpec.describe Admin::Views::Users::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/users/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    expect(view.foo).to eq exposures.fetch(:foo)
  end

  describe 'nav bar actions' do
    it { expect(view.dashboard_active?).to be false }
    it { expect(view.moderation_active?).to be false }
    it { expect(view.tasks_active?).to be false }
    it { expect(view.users_active?).to be true }
  end
end
