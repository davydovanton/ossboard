module Api::Controllers::Issue
  class Show
    include Api::Action

    params do
      required(:issue_url).filled(:str?)
    end

    # curl -i "https://api.github.com/repos/hanami/hanami/issues/663"
    def call(params)
      response = if params.valid?
        match_host(params[:issue_url])
      else
        { error: 'empty url' }
      end

      self.body = JSON.generate(response)
    end

  private

    def match_host(issue_url)
      GitHostMatcher.(issue_url) do |m|
        m.success(:github) { |issue_data| GithubIssueRequester.(issue_data) }
        m.failure { |p| p }
      end
    end
  end
end
