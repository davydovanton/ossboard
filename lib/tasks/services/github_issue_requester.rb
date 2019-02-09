require 'dry/monads/result'

module Tasks
  module Services
    class GithubIssueRequester
      include Dry::Monads::Result::Mixin

      def call(params)
        result = issue_data(params).fmap { |data| data.merge(repo_data(params)) }

        case result
        when Success
          result.value!
        when Failure
          result.failure
        end
      end

    private

      ERROR_HASH = { error: 'invalid url' }

      GITHUB_REPO_API_URL = 'https://api.github.com/repos/%{org}/%{repo}'.freeze
      GITHUB_ISSUE_API_URL = 'https://api.github.com/repos/%{org}/%{repo}/issues/%{issue}'.freeze
      COMPLEXITY_LABELS = %w(easy medium hard).freeze

      def get_response(url)
        Container['core.http_request'].get(url)
      end

      def issue_data(params)
        response = get_response(GITHUB_ISSUE_API_URL % params)
        return Failure(ERROR_HASH) unless response.is_a?(Net::HTTPSuccess)

        data = JSON.parse(response.body)
        Success(
          html_url: data['html_url'],
          title: data['title'],
          body: data['body'],
          complexity: issue_complexity(data)
        )
      end

      def issue_complexity(data)
        data['labels']
          .map! { |label| label['name'].downcase }
          .find { |label| COMPLEXITY_LABELS.include?(label) }
      end

      def repo_data(params)
        response = get_response(GITHUB_REPO_API_URL % params)
        return {} unless response.is_a?(Net::HTTPSuccess)

        data = JSON.parse(response.body)
        { lang: data['language'].downcase, repository_name: data['name'] }
      end
    end
  end
end
