module Api::Controllers::Issue
  class Show
    include Api::Action

    params do
      required(:issue_url).filled(:str?)
    end

    def call(params)
      response = params.valid? ? match_host(params[:issue_url]) : { error: 'empty url' }
      self.body = JSON.generate(response)
    end

  private

    def match_host(issue_url)
      GitHostMatcher.(issue_url) do |m|
        m.success(:github) { |issue_data| GithubIssueRequester.(issue_data) }
        m.success(:gitlab) { { error: 'Sorry, but gitlab is not supported now' } }
        m.failure { { error: 'invalid url' } }
      end
    end
  end
end
