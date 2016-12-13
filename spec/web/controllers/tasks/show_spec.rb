require 'spec_helper'
require_relative '../../../../apps/web/controllers/tasks/show'

RSpec.describe Web::Controllers::Tasks::Show do
  let(:action) { described_class.new }
  let(:task) { TaskRepository.new.create(title: 'test') }
  let(:params) { { id: task.id } }

  after { TaskRepository.new.clear }

  it { expect(action.call(params)).to be_success }

  describe 'expose' do
    context '#task' do
      it 'returns task by id' do
        action.call(params)
        expect(action.task).to eq task
      end
    end

    context '#author' do
      let(:author) { UserRepository.new.create(name: 'test') }
      let(:task) { TaskRepository.new.create(title: 'test', user_id: author.id) }

      it 'returns author of task' do
        action.call(params)
        expect(action.author).to eq author
      end

      context 'when author is empty (unreal case)' do
        let(:task) { TaskRepository.new.create(title: 'test') }

        it 'returns author of task' do
          action.call(params)
          expect(action.author.name).to eq 'Anonymous'
        end
      end
    end
  end
end
