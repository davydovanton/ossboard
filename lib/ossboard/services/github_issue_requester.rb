require_relative '../../get_request'

class GithubIssueRequester
  def self.call(params)
    new.call(params)
  end

  def call(params)
    issue_response = get_response(GITHUB_ISSUE_API_URL % params)
    issue_data = JSON.parse(issue_response.body)

    data = { html_url: issue_data['html_url'], title: issue_data['title'], description: issue_data['body'] }

    return ERROR_HASH unless issue_response.is_a?(Net::HTTPSuccess)

    repo_response = get_response(GITHUB_REPO_API_URL % params)
    repo_data = JSON.parse(repo_response.body)

    if repo_response.is_a?(Net::HTTPSuccess)
      data = data.merge(
        lang: repo_data['language'].downcase,
        repository_name: repo_data['name']
      )
    end

    data
  end

  private

  ERROR_HASH = { error: 'invalid url' }.freeze

  GITHUB_REPO_API_URL = 'https://api.github.com/repos/%{org}/%{repo}'.freeze
  GITHUB_ISSUE_API_URL = 'https://api.github.com/repos/%{org}/%{repo}/issues/%{issue}'.freeze

  def get_response(url)
    GetRequest.new.call(url)
  end
end
