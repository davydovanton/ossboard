require_relative '../../../../apps/web/controllers/tasks/index'

RSpec.describe Web::Controllers::Tasks::Index do
  let(:action) { described_class.new }
  let(:params) { Hash[] }
  let(:repo) { TaskRepository.new }

  it { expect(action.call(params)).to be_success }

  describe 'expose' do
    describe '#tasks' do
      before do
        3.times { |i| Fabricate.create(:task, title: "title ##{i}", approved: true, status: 'done',        lang: 'ruby') }
        3.times { |i| Fabricate.create(:task, title: "title ##{i}", approved: true, status: 'closed',      lang: 'haskell') }
        3.times { |i| Fabricate.create(:task, title: "title ##{i}", approved: true, status: 'in progress', lang: 'unknown', repository_name: 'ossboard') }
        3.times { |i| Fabricate.create(:task, title: "title ##{i}", approved: true, status: 'moderation',  lang: 'elixir') }
        action.call(params)
      end

      it 'returns all tasks' do
        expect(action.tasks).to all(be_a(Task))
        expect(action.tasks.count).to eq 3
      end

      context 'when repository param is ossboard' do
        let(:params)  { { repository: 'ossboard' } }

        it 'returns all done tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:repository_name)).to all(eq('ossboard'))
        end
      end

      context 'when status param is done' do
        let(:user) { Fabricate.create(:user, admin: false) }
        let(:params)  { { 'rack.session' => { current_user: user }, status: 'moderation' } }

        before do
          3.times { |i| Fabricate.create(:task, approved: false, user_id: user.id) }
          3.times { |i| Fabricate.create(:task, approved: nil, user_id: user.id) }
          action.call(params)
        end

        it 'returns all done tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:user_id)).to all(eq(user.id))
        end
      end

      context 'when status param is done' do
        let(:params) { { status: 'done' } }

        it 'returns all done tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('done'))
        end
      end

      context 'when status param is invalid' do
        let(:params) { { status: 'invalid' } }

        it 'returns all done tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('in progress'))
        end
      end

      context 'when status param is in closed' do
        let(:params) { { status: 'closed' } }

        it 'returns all closed tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('closed'))
        end
      end

      context 'when status param is in progress' do
        let(:params) { { status: 'in progress' } }

        it 'returns all in progress tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('in progress'))
        end
      end

      context 'when status param is on moderation' do
        let(:user) { Fabricate.create(:user, admin: false) }
        let(:params) { { status: 'moderation' } }

        it 'returns all tasks on moderation' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('moderation'))
        end
      end

      context 'when lang param is unknown' do
        let(:params) { { lang: 'unknown' } }

        it 'returns all tasks with unknown lang' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:lang)).to all(eq('unknown'))
        end
      end

      context 'when lang param is ruby and status param is done' do
        let(:params) { { lang: 'ruby', status: 'done' } }

        it 'returns all ruby tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('done'))
          expect(action.tasks.map(&:lang)).to all(eq('ruby'))
        end
      end

      context 'when lang param is haskell and status is done' do
        let(:params) { { lang: 'haskell', status: 'done' } }

        it 'returns all done tasks with haskell lang' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 0
        end
      end

      context 'when lang param is valid' do
        before do
          Task::VALID_LANGUAGES.keys.map.with_index do |lang_name, index|
            Fabricate.create(:task, title: "title ##{index}", approved: true, status: 'done', lang: lang_name.to_s)
          end
        end

        it 'returns all tasks with respective language' do
          Task::VALID_LANGUAGES.keys.map(&:to_s).each do |lang_name|
            action.call(lang: lang_name, status: 'done')
            expect(action.tasks).to all(be_a(Task))
            expect(action.tasks.map(&:lang)).to all(eq(lang_name))
          end
        end
      end

      context 'when lang param is invalid and status is invalid' do
        let(:params) { { lang: 'test', status: 'test' } }

        it 'returns all in progress tasks' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 3
          expect(action.tasks.map(&:status)).to all(eq('in progress'))
        end
      end

      context 'when are on the first page' do
        let(:params) { { lang: 'ruby', status: 'done', page: 1} }

        before do
          8.times { |i| Fabricate.create(:task, title: "title ##{i}", approved: true, status: 'done',        lang: 'ruby') }
          action.call(params)
        end

        it 'returns 10 tasks on page' do

          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 10
          expect(action.tasks.map(&:status)).to all(eq('done'))
        end

      end

      context 'when are on the second page' do
        let(:params) { { lang: 'ruby', status: 'done', page: 2} }

        before do
          8.times { |i| Fabricate.create(:task, title: "title ##{i}", approved: true, status: 'done',        lang: 'ruby') }
          action.call(params)
        end

        it 'returns 1 task on page' do
          expect(action.tasks).to all(be_a(Task))
          expect(action.tasks.count).to eq 1
          expect(action.tasks.map(&:status)).to all(eq('done'))
        end

      end


    end
  end
end
