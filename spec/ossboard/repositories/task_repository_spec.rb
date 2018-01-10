RSpec.describe TaskRepository do
  let(:repo) { TaskRepository.new }

  describe '#find_by' do
    before do
      Fabricate.create(:task, title: 'in progress', approved: true, status: 'in progress', lang: 'ruby')
      Fabricate.create(:task, title: 'closed', approved: true, status: 'closed', lang: 'haskell')
      Fabricate.create(:task, title: 'done', approved: true, status: 'done', lang: 'unknown')
    end

    context 'when params is empty' do
      it 'returns array of closed tasks' do
        result = repo.find_by(approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 3
      end
    end

    context 'when status is closed' do
      it 'returns array of closed tasks' do
        result = repo.find_by(status: 'closed', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.status).to eq 'closed'
      end
    end

    context 'when status is done' do
      it 'returns array of done tasks' do
        result = repo.find_by(status: 'done', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.status).to eq 'done'
      end
    end

    context 'when status is in progress' do
      it 'returns array of in progress tasks' do
        result = repo.find_by(status: 'in progress', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.status).to eq 'in progress'
      end
    end

    context 'when lang is ruby' do
      it 'returns array of ruby language tasks' do
        result = repo.find_by(lang: 'ruby', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.lang).to eq 'ruby'
      end
    end

    context 'when lang is haskell' do
      it 'returns array of haskell language tasks' do
        result = repo.find_by(lang: 'haskell', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.lang).to eq 'haskell'
      end
    end

    context 'when lang is unknown' do
      it 'returns array of unknown language tasks' do
        result = repo.find_by(lang: 'unknown', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.lang).to eq 'unknown'
      end
    end

    context 'when status is in progress and lang is ruby' do
      it 'returns array of in progress, ruby tasks' do
        result = repo.find_by(status: 'in progress', lang: 'ruby', approved: true)
        expect(result).to all(be_a(Task))
        expect(result.count).to eq 1
        expect(result.first.lang).to eq 'ruby'
        expect(result.first.status).to eq 'in progress'
      end
    end
  end

  describe '#only_approved' do
    before do
      Fabricate.create(:task, title: 'bad')
      Fabricate.create(:task, title: 'good', approved: true)
    end

    it 'returns only approved tasks' do
      result = repo.only_approved
      expect(result).to all(be_a(Task))
      expect(result.size).to eq 1
      expect(result.last.title).to eq 'good'
    end
  end

  describe '#not_approved' do
    before do
      Fabricate.create(:task, title: 'bad')
      Fabricate.create(:task, title: 'new',  approved: nil)
      Fabricate.create(:task, title: 'good', approved: true)
    end

    it 'returns not approved tasks' do
      result = repo.not_approved
      expect(result).to all(be_a(Task))
      expect(result.size).to eq 1
      expect(result.last.title).to eq 'bad'
    end
  end

  describe '#new_tasks' do
    before do
      Fabricate.create(:task, title: 'bad')
      Fabricate.create(:task, title: 'new',  approved: nil)
      Fabricate.create(:task, title: 'good', approved: true)
    end

    it 'returns not approved tasks' do
      result = repo.new_tasks
      expect(result).to all(be_a(Task))
      expect(result.size).to eq 1
      expect(result.last.title).to eq 'new'
    end
  end

  describe '#all_from_date' do
    before do
      3.times do |i|
        random_days_count = i * 60 * 60 * 24
        Timecop.freeze(Time.utc(2016, 02, 20) - random_days_count) do
          Fabricate.create(:task, status: 'done')
          Fabricate.create(:task, status: 'in progress')
          Fabricate.create(:task, status: 'closed')
          Fabricate.create(:task, status: 'assigned')
        end
      end

      Timecop.freeze(Time.now + (2 * 60 * 60 * 24)) { Fabricate.create(:task) }
    end

    let(:date) { Date.new(2016, 02, 18) }

    it 'returns array of tasks' do
      expect(repo.all_from_date(date)).to be_a(Array)
      expect(repo.all_from_date(date).count).to eq 8
    end

    it 'returns correct tasks for statuses' do
      expect(repo.all_from_date(date, 'in progress').count).to eq 2
      expect(repo.all_from_date(date, 'done').count).to eq 2
      expect(repo.all_from_date(date, 'closed').count).to eq 2
      expect(repo.all_from_date(date, 'assigned').count).to eq 2
    end
  end

  describe '#all_from_date_counted_by_status_and_day' do
    before do
      (-2..2).each do |days_count|
        Timecop.freeze(Time.utc(2016, 02, 20 + days_count)) do
          Fabricate.create(:task, status: 'done')
          Fabricate.create(:task, status: 'in progress')
          Fabricate.create(:task, status: 'closed')
          Fabricate.create(:task, status: 'assigned')
        end
      end
    end

    it 'returns correct tasks' do
      result = repo.all_from_date_counted_by_status_and_day(Time.utc(2016, 02, 20))
      expect(result).to be_a(Hash)
      expect(result['done'].count).to eq 2
      expect(result.dig('closed', Date.new(2016, 02, 22))).to eq 1
    end
  end

  describe '#on_moderation_for_user' do
    before do
      Fabricate.create(:task, assignee_username: 'davydovanton')
      Fabricate.create(:task, assignee_username: 'davydovanton')
      Fabricate.create(:task, assignee_username: 'test')
    end

    let(:user) { User.new(login: 'davydovanton') }

    it 'returns array of tasks' do
      result = repo.assigned_tasks_for_user(user)
      expect(result).to all(be_a(Task))
      expect(result.count).to eq 2
    end
  end
end
