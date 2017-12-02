require_relative '../../features_helper'

module TasksPageHelper

  def fill_md_text
    page.find('.task-body__write > #task-md-body').set md_text
  end

  def expect_write
    expect(page).to have_css('button.btn.btn-default.pure-menu-link', text: 'Preview')
    expect(page).not_to have_css('button.btn.btn-default.pure-menu-link', text: 'Write')
    expect(page.find('.task-body__write > #task-md-body').value).to eq(md_text)
  end

  def expect_preview
    md_html = File.read(File.expand_path('../../../support/markdown/text.html', __FILE__))
    expect(page).to have_css('button.btn.btn-default.pure-menu-link', text: 'Write')
    expect(page).not_to have_css('button.btn.btn-default.pure-menu-link', text: 'Preview')
    page.find('#previewed-text > :first-child') && (expect(page.find('#previewed-text')['innerHTML']).to eq(md_html))
  end

  def expect_issue(title:, repository_name:, url:, language:, content:)
    expect(find('#task-title').value).to eq(title)
    expect(find('#task-repository-name').value).to eq(repository_name)
    expect(find('#task-issue-url').value).to eq(url)
    expect(find('#task-lang').value).to eq(language)
    expect(find('#task-md-body').value).to start_with(content)
  end

  def export(url)
    find('.new-task__import-button').click
    find('#issueUrl').set url
    find('.button.modal-submit').click
    sleep(Capybara.default_max_wait_time)
  end

  def expect_task(task)
    expect(find('#task-status-select').value).to eq(task.status)
    expect(page).to have_css('.task-item', count: 1)
    expect(page).to have_css('.task-item__title', text: task.title)
    expect(page).to have_css('a[href="/users/' + task.author.login + '"]', text: task.author.name)
    expect(page).to have_css('.task-item__estimate', text: 'Estimated time: ' + task.time_estimate)
    expect(page).to have_css(".task-item__complexity > .level-#{task.complexity}", text: task.complexity.upcase)
  end

end

RSpec.describe 'Tasks page', type: :feature do

  include TasksPageHelper

  describe '#index' do

    let!(:open_task)     { Fabricate.create(:task, user_id: Fabricate.create(:user).id, approved: true, status: 'in progress', time_estimate: 'few days', comlexity: 'easy') }
    let!(:assigned_task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id, approved: true, status: 'assigned', time_estimate: 'more than a week', comlexity: 'medium') }
    let!(:closed_task)   { Fabricate.create(:task, user_id: Fabricate.create(:user).id, approved: true, status: 'closed', time_estimate: 'more than two weeks', comlexity: 'hard') }
    let!(:finished_task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id, approved: true, status: 'done', time_estimate: 'more than month', comlexity: 'easy') }
    let(:repo) { UserRepository.new }

    it 'status filter in default position "Open"' do
      visit '/tasks'
      expect_task(open_task)
    end

    it 'status filter in position "Assigned"' do
      visit '/tasks?status=assigned'
      expect_task(assigned_task)
    end

    it 'status filter in position "Closed"' do
      visit '/tasks?status=closed'
      expect_task(closed_task)
    end

    it 'status filter in position "Finished"' do
      visit '/tasks?status=done'
      expect_task(finished_task)
    end

  end

  describe '#new', js: true do

    before(:each) { visit '/tasks/new' }

    context 'switchers' do
      let(:md_text) { File.read(File.expand_path('../../../support/markdown/text.md', __FILE__)) }

      it 'switcher on new page with "Description" default switch position' do
        fill_md_text
        expect_write
      end

      it '"Preview" switch position and return to "Description" position' do
        fill_md_text

        page.find('button.btn.btn-default.pure-menu-link', text: 'Preview').click
        expect_preview

        page.find('button.btn.btn-default.pure-menu-link', text: 'Write').click
        expect_write
      end
    end

    context 'export button logic' do
      let(:github_url) { 'https://github.com/ossboard-org/ossboard/issues/69' }
      let(:github_url_without_complexity) { 'https://github.com/davydovanton/shallow_attributes/issues/8' }
      let(:github_content) { 'Currently, for the big screen, footer has not fixed to page bottom.' }
      let(:github_title) { 'Footer has not fixed to page bottom' }

      let(:gitlab_url) { 'https://gitlab.com/gitlab-org/gitlab-ce/issues/28059' }
      let(:gitlab_title) { 'No pagination on abuse_reports' }
      let(:gitlab_repo) { 'GitLab Community Edition' }
      let(:gitlab_content) { 'We removed' }

      it 'show "Export from" dialog on button click and hide on overlay click' do
        expect(page).not_to have_css('.modal-container')

        find('.new-task__import-button').click

        expect(find('.modal-container')).to be_visible
        expect(find('.modal-header h3')).to have_content('Export from')

        page.driver.browser.click_coordinates(0, 0)

        expect(page).not_to have_css('.modal-container')
      end

      it 'incorrect url message' do
        export('http://google.com')
        expect(page).to have_css('.modal-error', text: 'Error: invalid url')
      end

      xit 'export github issue' do
        VCR.use_cassette('github_success_issue') do
          export(github_url)
          expect_issue(title: github_title, repository_name: 'ossboard', url: github_url, language: 'ruby', content: github_content)
        end
      end

      it 'export github issue without complexity' do
        VCR.use_cassette('github_success_issue_without_complexity') do
            export(github_url_without_complexity)
            expect(find('#task-complexity').value).to start_with('easy')
        end
      end

      xit 'export gitlab issue' do
        VCR.use_cassette('gitlab_success_issue') do
          export(gitlab_url)
          expect_issue(title: gitlab_title, repository_name: gitlab_repo, url: gitlab_url, language: '', content: gitlab_content)
        end
      end
    end

  end

end
