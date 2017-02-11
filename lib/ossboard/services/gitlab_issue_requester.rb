require_relative '../../http_request'

class GitlabIssueRequester
  def self.call(params)
    new.call(params)
  end

  def call(params)
    issue_response = get_response(GITLAB_ISSUE_API_URL % params)
    repo_response = get_response(GITLAB_REPO_API_URL % params)

    repo_data = JSON.parse(repo_response.body)
    issue_data = JSON.parse(issue_response.body)

    return parse_errors(issue_response) unless issue_response.is_a?(Net::HTTPSuccess)
    return ERROR_HASH unless Array(issue_data).size == 1

    issue_data = issue_data.first

    data = {
      html_url: issue_data['web_url'],
      title: issue_data['title'],
      description: issue_data['description']
    }

    data[:repository_name] = repo_data['name'] if repo_response.is_a?(Net::HTTPSuccess)

    data
  end

  private

  GITLAB_REPO_API_URL = 'https://gitlab.com/api/v3/projects/%{org}%%2F%{repo}'.freeze
  GITLAB_ISSUE_API_URL = 'https://gitlab.com/api/v3/projects/%{org}%%2F%{repo}/issues/?iid=%{issue}'.freeze

  MESSAGE_KEY = 'message'.freeze
  ERROR_HASH = { error: 'invalid url' }.freeze
  ERROR_UNATHORIZED_HASH = { error: 'Unauthorized' }.freeze

  def parse_errors(issue_response)
    response_data = JSON.parse(issue_response.body)
    response_data.fetch(MESSAGE_KEY, {}).include?("Unauthorized") ?
      ERROR_UNATHORIZED_HASH : ERROR_HASH
  end

  def get_response(url)
    HttpRequest.new(url).get do |request|
      request['PRIVATE-TOKEN'] = ENV['GITLAB_PRIVATE_TOKEN']
    end
  end
end
