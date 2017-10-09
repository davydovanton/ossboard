require 'dry-container'
require 'dry-auto_inject'

%w[markdown http_request].each { |file| require_relative "ossboard/core/#{file}" }

%w[
  analytic_reporter url_shortener task_tweeter
].each { |file| require_relative "ossboard/services/#{file}" }

require_relative 'tasks/matchers/git_host'

%w[github_issue_requester gitlab_issue_requester].each { |file| require_relative "tasks/services/#{file}" }

class Container
  extend Dry::Container::Mixin

  register('core.markdown', Core::Markdown.new)
  register('core.http_request', Core::HttpRequest.new)

  namespace('services') do
    register('analytic_reporter', Services::AnalyticReporter.new)
    register('task_twitter', Services::TaskTwitter.new)
    register('url_shortener', Services::UrlShortener.new)
  end

  namespace('tasks') do
    namespace('interactors') do
      register('create') { Tasks::Interactors::Create }
      register('update') { Tasks::Interactors::Update }
      register('update_status') { Tasks::Interactors::UpdateStatus }
      register('issue_information') { Tasks::Interactors::IssueInformation }
    end

    namespace('services') do
      register('github_issue_requester', Tasks::Services::GithubIssueRequester.new)
      register('gitlab_issue_requester', Tasks::Services::GitlabIssueRequester.new)
    end

    register('matchers.git_host', Tasks::Matchers::GitHost::Matcher)
  end
end

Import = Dry::AutoInject(Container)
