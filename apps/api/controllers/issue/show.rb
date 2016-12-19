module Api::Controllers::Issue
  class Show
    include Api::Action

    params do
      required(:issue_url).filled(:str?)
    end

    # curl -i "https://api.github.com/repos/hanami/hanami/issues/663"
    def call(params)
      response = if params.valid?
        { hello: :world }
      else
        { error: 'empty url' }
      end

      self.body = JSON.generate(response)
    end
  end
end
