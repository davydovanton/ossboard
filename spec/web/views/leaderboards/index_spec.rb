require_relative '../../../../apps/web/views/leaderboards/index'

RSpec.describe Web::Views::Leaderboards::Index do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/leaderboards/index.html.slim') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  describe 'exposes' do
    describe '#users' do
      it { expect(view.users).to all(be_an(User)) }
    end
  end
end
